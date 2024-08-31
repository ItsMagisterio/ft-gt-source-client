package alternativa.tanks.models.battlefield.effects.graffiti
{
    import alternativa.engine3d.objects.Decal;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.math.Vector3;
    import alternativa.tanks.physics.CollisionGroup;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.engine3d.materials.TextureMaterial;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import flash.media.Sound;
    import alternativa.tanks.models.battlefield.decals.RotationState;
    import flash.display.BitmapData;
    import alternativa.tanks.sfx.ISound3DEffect;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.Sound3DEffect;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import flash.utils.Dictionary;
    import specter.utils.Logger;
    import alternativa.engine3d.core.MipMapping;
    import alternativa.console.IConsole;

    public class GraffitiManager
    {

        private static var battlefieldModel:BattlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);

        public static var decals:Dictionary = new Dictionary();

        public static var ALPHA_DURATION:int = 1000;

        public static var takenAnimationTime:int = 1000;

        public static var takeAnimationEnabled:Boolean = false;

        public static var decalToBeRemoved:Decal = null;

        public static function putGraffiti(id:String):void
        {
            var js:Object;
            var ray:RayIntersection = new RayIntersection();
            var origin:Vector3 = new Vector3(battlefieldModel.getBattlefieldData().viewport.camera.x, battlefieldModel.getBattlefieldData().viewport.camera.y, battlefieldModel.getBattlefieldData().viewport.camera.z);
            var direction:Vector3 = new Vector3(battlefieldModel.getBattlefieldData().viewport.camera.zAxis.x, battlefieldModel.getBattlefieldData().viewport.camera.zAxis.y, battlefieldModel.getBattlefieldData().viewport.camera.zAxis.z);
            if (battlefieldModel.getBattlefieldData().collisionDetector.raycastStatic(origin, direction, CollisionGroup.STATIC, 10000000000000000, ray))
            {
                js = new Object();
                js.rayPos = ray.pos;
                js.origin = origin;
                // Network(Main.osgi.getService(INetworker)).send(((("battle;activate_graffiti;" + id) + ";") + JSON.stringify(js)));
            }
        }

        public static function createGraffiti(originPos:Vector3, name:String, id:String):void
        {
            var hasHit:Boolean = false;
            var retryCount:Number = 0;
            originPos.z += 3000;
            var texture:TextureMaterial = new TextureMaterial(getTexture(name), false, true, MipMapping.PER_PIXEL, 2.5);

            var ray:RayIntersection = new RayIntersection();
            var offsetPerTick:int = 5;
            var retries:int = 10;
            var all:int = retries * offsetPerTick;

            while (!hasHit && retryCount < retries)
            {
                retryCount++;
                originPos.y += offsetPerTick;
                originPos.x += offsetPerTick;
                if (battlefieldModel.getBattlefieldData().collisionDetector.intersectRayWithStatic(originPos, new Vector3(0, 0, -1), CollisionGroup.STATIC, 100000000000000000000, null, ray))
                {
                    hasHit = true;
                    decals[id] = battlefieldModel.addDecal(ray.pos, originPos, 230, texture, RotationState.WITHOUT_ROTATION, true);
                }
            }
            if (retryCount == retries)
            {
                retryCount = 0;
                originPos.y -= all;
                originPos.x -= all;
                while (!hasHit && retryCount < retries)
                {
                    retryCount++;
                    originPos.y -= offsetPerTick;
                    originPos.x -= offsetPerTick;
                    if (battlefieldModel.getBattlefieldData().collisionDetector.intersectRayWithStatic(originPos, new Vector3(0, 0, -1), CollisionGroup.STATIC, 100000000000000000000, null, ray))
                    {
                        hasHit = true;
                        decals[id] = battlefieldModel.addDecal(ray.pos, originPos, 230, texture, RotationState.WITHOUT_ROTATION, true);
                    }
                }
            }
            if (retryCount == retries)
            {
                retryCount = 0;
                originPos.y += all;
                originPos.x += all;
                while (!hasHit && retryCount < retries)
                {
                    retryCount++;
                    originPos.y -= offsetPerTick;
                    originPos.x += offsetPerTick;
                    if (battlefieldModel.getBattlefieldData().collisionDetector.intersectRayWithStatic(originPos, new Vector3(0, 0, -1), CollisionGroup.STATIC, 100000000000000000000, null, ray))
                    {
                        hasHit = true;
                        decals[id] = battlefieldModel.addDecal(ray.pos, originPos, 230, texture, RotationState.WITHOUT_ROTATION, true);
                    }
                }
            }
            if (retryCount == retries)
            {
                retryCount = 0;
                originPos.y += all;
                originPos.x -= all;
                while (!hasHit && retryCount < retries)
                {
                    retryCount++;
                    originPos.y += offsetPerTick;
                    originPos.x -= offsetPerTick;
                    if (battlefieldModel.getBattlefieldData().collisionDetector.intersectRayWithStatic(originPos, new Vector3(0, 0, -1), CollisionGroup.STATIC, 100000000000000000000, null, ray))
                    {
                        hasHit = true;
                        decals[id] = battlefieldModel.addDecal(ray.pos, originPos, 230, texture, RotationState.WITHOUT_ROTATION, true);
                    }
                }
            }
            if (retryCount == retries)
            {
                retryCount = 0;
                originPos.y -= all;
                originPos.x += all;
                while (!hasHit && retryCount < retries)
                {
                    retryCount++;
                    originPos.y += offsetPerTick;
                    originPos.x += offsetPerTick;
                    originPos.z += 2000;
                    if (battlefieldModel.getBattlefieldData().collisionDetector.intersectRayWithStatic(originPos, new Vector3(0, 0, -1), CollisionGroup.STATIC, 100000000000000000000, null, ray))
                    {
                        hasHit = true;
                        decals[id] = battlefieldModel.addDecal(ray.pos, originPos, 230, texture, RotationState.WITHOUT_ROTATION, true);
                    }
                }
                trace("bug still happens for sum reasun");
            }
        }

        public static function removeGraffiti(graffiti:String):void
        {
            battlefieldModel.removeDecal(decals[graffiti]);
        }

        private static function getTexture(id:String):BitmapData
        {
            return (TexturesManager.getBD(id));
        }
        public static function playSoundEffect(effectSound:Sound, pos:Vector3):void
        {
            var soundEffect:ISound3DEffect = createSoundEffect(effectSound, pos);
            if (soundEffect != null)
            {
                battlefieldModel.addSound3DEffect(soundEffect);
            }
        }
        private static function createSoundEffect(effectSound:Sound, pos:Vector3):ISound3DEffect
        {
            var sound:Sound3D = Sound3D.create(effectSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 1.5);
            return (Sound3DEffect.create(IObjectPoolService(Main.osgi.getService(IObjectPoolService)).objectPool, null, pos, sound));
        }

    }
}
