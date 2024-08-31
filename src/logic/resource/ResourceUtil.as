// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.ResourceUtil

package logic.resource
{
    import __AS3__.vec.Vector;
    import logic.resource.tanks.TankResourceLoader;
    import logic.resource.images.ImageResourceLoader;
    import flash.utils.Dictionary;
    import logic.resource.images.ImageResourceList;
    import alternativa.tanks.model.GarageModel;
    import specter.utils.Logger;
    import logic.resource.listener.ResourceLoaderListener;
    import com.alternativaplatform.projects.tanks.client.commons.types.TankParts;
    import __AS3__.vec.*;

    public class ResourceUtil
    {

        public static var loading:Vector.<String>;
        public static var isInBattle:Boolean = false;
        private static var loaderSounds:SoundResourceLoader;
        private static var loaderModels:TankResourceLoader;
        private static var loaderImages:ImageResourceLoader;
        private static var sfxMap:Dictionary;
        public static var resourceLoaded:Boolean;
        private static var resourcesLength:int;

        public function ResourceUtil()
        {
            throw (new Error("ResourceUtil is a static class and should not be instantiated."));
        }
        public static function getResource(_arg_1:ResourceType, key:String, garage:Boolean = false):Object
        {
            var returningResource:Object;
            if ((!(resourceLoaded)))
            {
                return (null);
            }
            switch (_arg_1)
            {
                case ResourceType.IMAGE:
                    if ((!(isInBattle)))
                    {
                        returningResource = loaderImages.list.getImage(key);
                    }
                    else if (garage)
                    {
                        returningResource = loaderImages.list.getImage(key);
                    }
                    else
                    {
                        returningResource = loaderImages.inbattleList.getImage(key);
                    }
                    break;
                case ResourceType.MODEL:
                    returningResource = loaderModels.list.getModel(key);
                    break;
                case ResourceType.SOUND:
                    returningResource = loaderSounds.list.getSound(key);
            }
            return (returningResource);
        }
        public static function checkBitmaps():void
        {
            trace("finish");
        }
        public static function loadResource():void
        {
            sfxMap = new Dictionary();
            sfxMap["railgun"] = "shot, chargingPart1, chargingPart2, chargingPart3";
            sfxMap["railgunxt"] = "shot, chargingPart1, chargingPart2, chargingPart3";
            sfxMap["smoky"] = "shot, explosion";
            sfxMap["smokyxt"] = "shot, explosion";
            sfxMap["flamethrower"] = "fire";
            sfxMap["twins"] = "explosionTexture, plasmaTexture, shotTexture";
            sfxMap["twins_xt"] = "explosionTexture, plasmaTexture, shotTexture";
            sfxMap["twinsxt"] = "explosionTexture, plasmaTexture, shotTexture";
            sfxMap["isida"] = "damagingRayId, damagingTargetBallId, damagingWeaponBallId, healingRayId, healingTargetBallId, healingWeaponBallId, idleWeaponBallId";
            sfxMap["thunder"] = "explosionResourceId, shotResourceId";
            sfxMap["thunder_xt"] = "explosionResourceId, shotResourceId";
            sfxMap["hwthunder"] = "explosionResourceId, shotResourceId";
            sfxMap["frezee"] = "particleTextureResourceId, planeTextureResourceId";
            sfxMap["frezeeny"] = "particleTextureResourceId, planeTextureResourceId";
            sfxMap["ricochet"] = "bumpFlashTextureId, explosionTextureId, shotFlashTextureId, shotTextureId, tailTrailTextureId";
            sfxMap["pumpkingun"] = "bumpFlashTextureId, explosionTextureId, shotFlashTextureId, shotTextureId, tailTrailTextureId";
            sfxMap["shaft"] = "explosionTexture, shot, trail";
            sfxMap["terminator"] = "shot, chargingPart1, chargingPart2, chargingPart3";
            sfxMap["snowman"] = "shot, fire, snow";
            loading = new Vector.<String>();
            loaderSounds = new SoundResourceLoader(("sounds.tara"));
            loaderModels = new TankResourceLoader(("models.tara"));
            loaderImages = new ImageResourceLoader(("images.tara"));
        }
        public static function loadImages():void
        {
            isInBattle = false;
            resourceLoaded = true;
            // loaderImages.reload();
        }
        public static function unloadImages(saveList:Vector.<String> = null):void
        {
            var s:String;
            var s1:String;
            isInBattle = true;
            onCompleteLoading();
        }
        public static function onCompleteLoading():void
        {
            if ((((loaderImages.status == 1) && (loaderSounds.status == 1)) && (loaderModels.status == 1)))
            {
                trace("загрузка завершена");
                resourceLoaded = true;
                ResourceLoaderListener.loadedComplete();
                ResourceLoaderListener.clearListeners();
            }
        }
        public static function addEventListener(src:Function):Function
        {
            ResourceLoaderListener.addEventListener(src);
            return (src);
        }
        public static function loadGraphicsFor(parts:TankParts):void
        {
            var s:String;
            if (isDataPresent(parts))
            {
                onCompleteLoading();
            }
            // var toLoad:Vector.<String> = getLoadList(parts);
            // for each (s in toLoad) {
            // loaderImages.loadForBattle(s);
            // }
            // toLoad = null;
        }
        public static function loadGraphics(toLoad:Vector.<String>):void
        {
            var s:String;
            for each (s in toLoad)
            {
                if (loaderImages.inbattleList.isLoaded(s))
                {
                    trace("Good");
                }
            }
            loaderImages.loadFor(s);
            // }
        }
        public static function getLoadListSingle(id:String):Vector.<String>
        {
            var s:String;
            var toLoad:Vector.<String> = new Vector.<String>();
            toLoad.push((id + "_lightmap"));
            toLoad.push((id + "_details"));
            var partID:String = id.split("_")[0];
            if (sfxMap[partID])
            {
                for each (s in sfxMap[partID].split(", "))
                {
                    toLoad.push(((id + "_") + s));
                }
            }
            return (toLoad);
        }
        public static function getLoadList(parts:TankParts):Vector.<String>
        {
            var s:String;
            var toLoad:Vector.<String> = new Vector.<String>();
            toLoad.push((parts.hullObjectId + "_lightmap"));
            toLoad.push((parts.hullObjectId + "_details"));
            toLoad.push((parts.turretSkinId + "_lightmap"));
            toLoad.push((parts.turretSkinId + "_details"));
            toLoad.push((parts.turretObjectId + "_lightmap"));
            toLoad.push((parts.turretObjectId + "_details"));
            toLoad.push(parts.coloringObjectId);
            for each (s in sfxMap[parts.turretObjectId.split("_")[0]].split(", "))
            {
                toLoad.push(((parts.turretObjectId + "_") + s));
            }
            return (toLoad);
        }
        public static function isDataPresent(parts:TankParts):Boolean
        {
            var s:String;
            var toCheck:Vector.<String> = new Vector.<String>();
            toCheck.push((parts.hullObjectId + "_lightmap"));
            toCheck.push((parts.hullObjectId + "_details"));
            toCheck.push((parts.turretSkinId + "_lightmap"));
            toCheck.push((parts.turretSkinId + "_details"));
            toCheck.push((parts.turretObjectId + "_lightmap"));
            toCheck.push((parts.turretObjectId + "_details"));
            toCheck.push(parts.coloringObjectId);
            for each (s in toCheck)
            {
                if ((!(loaderImages.inbattleList.isLoaded(s))))
                {
                    return (false);
                }
            }
            toCheck = null;
            return (true);
        }

    }
} // package scpacker.resource