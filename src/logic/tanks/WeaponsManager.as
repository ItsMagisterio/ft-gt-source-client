// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.tanks.WeaponsManager

package logic.tanks
{
    import flash.utils.Dictionary;
    import alternativa.tanks.models.sfx.healing.HealingGunSFXModel;
    import alternativa.tanks.models.sfx.shoot.thunder.ThunderSFXModel;
    import alternativa.tanks.models.sfx.shoot.hwthunder.HWThunderSFXModel;
    import alternativa.tanks.models.weapon.freeze.FreezeSFXModel;
    import alternativa.tanks.models.sfx.shoot.ricochet.RicochetSFXModel;
    import alternativa.tanks.models.sfx.shoot.pumpkingun.PumpkingunSFXModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import alternativa.tanks.models.weapon.common.WeaponCommonModel;
    import alternativa.object.ClientObject;
    import alternativa.tanks.models.weapon.IWeapon;
    import alternativa.tanks.models.sfx.shoot.railgun.RailgunSFXModel;
    import alternativa.tanks.models.sfx.shoot.gun.SmokySFXModel;
    import alternativa.tanks.models.sfx.flame.FlamethrowerSFXModel;
    import alternativa.tanks.models.sfx.shoot.plasma.PlasmaSFXModel;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.healing.IHealingSFXModelBase;
    import alternativa.tanks.models.weapon.shaft.sfx.ShaftSFXModel;
    import alternativa.tanks.models.sfx.shoot.snowman.SnowmanSFXModel;
    import alternativa.tanks.models.sfx.shoot.ICommonShootSFX;
    import alternativa.register.ClientClass;
    import alternativa.tanks.models.weapon.common.ShotEffect;

    public class WeaponsManager
    {

        public static var shotDatas:Dictionary = new Dictionary();
        public static var specialEntity:Dictionary = new Dictionary();
        private static var railgunSFXModels:Dictionary = new Dictionary();
        private static var smokySFXModels:Dictionary = new Dictionary();
        private static var flamethrowerSFXModels:Dictionary = new Dictionary();
        private static var twinsSFXModels:Dictionary = new Dictionary();
        private static var isidaSFXModel:HealingGunSFXModel;
        private static var thunderSFXModels:ThunderSFXModel;
        private static var hwthunderSFXModels:HWThunderSFXModel;
        private static var frezeeSFXModels:FreezeSFXModel;
        private static var ricochetSFXModels:RicochetSFXModel;
        private static var pumpkingunSFXModels:PumpkingunSFXModel;
        private static var shaftSFXModel:Dictionary = new Dictionary();
        private static var turretObjects:Dictionary = new Dictionary();
        private static var snowmanSFXModels:Dictionary = new Dictionary();
        private static var terminatorSFXModels:Dictionary = new Dictionary();

        public static function getWeapon(owner:ClientObject, clientObject:ClientObject, impactForce:Number, kickback:Number, turretRotationAcceleration:Number, turretRotationSpeed:Number, shotEffectId:String):IWeapon
        {
            var model:WeaponCommonModel = (Main.osgi.getService(IWeaponCommonModel) as WeaponCommonModel);
            if (model == null)
            {
                model = new WeaponCommonModel();
                Main.osgi.registerService(IWeaponCommonModel, model);
            }
            model.initObject(clientObject, impactForce, kickback, turretRotationAcceleration, turretRotationSpeed, shotEffectId, owner);
            model.objectLoaded(clientObject);
            model.initWeaponController(clientObject, owner);
            return (model);
        }
        public static function getRailgunSFX(clientObject:ClientObject, ownerTank:ClientObject):RailgunSFXModel
        {
            var returned:RailgunSFXModel;
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            if (railgunSFXModels == null)
            {
                railgunSFXModels = new Dictionary();
            }
            if (railgunSFXModels[shotEffectId] == null)
            {
                railgunSFXModels[shotEffectId] = new RailgunSFXModel();
                (railgunSFXModels[shotEffectId] as RailgunSFXModel).initObject(clientObject, ((shotEffectId + "_") + "chargingPart1"), ((shotEffectId + "_") + "chargingPart2"), ((shotEffectId + "_") + "chargingPart3"), (shotEffectId + "_" + "shot"), shotEffectId + "_" + "ashot");
            }
            returned = railgunSFXModels[shotEffectId];
            if (returned == null)
            {
                throw (new Error(("SFX Model missing " + clientObject.id + " " + clientObject.getParams(ShotEffect))));
            }
            return (returned);
        }
        public static function getTerminatorSFX(clientObject:ClientObject):RailgunSFXModel
        {
            var returned:RailgunSFXModel;
            if (terminatorSFXModels == null)
            {
                terminatorSFXModels = new Dictionary();
            }
            if (terminatorSFXModels[clientObject.id] == null)
            {
                terminatorSFXModels[clientObject.id] = new RailgunSFXModel();
                terminatorSFXModels[clientObject.id].initObject(clientObject, ((clientObject.id + "_") + "chargingPart1"), ((clientObject.id + "_") + "chargingPart2"), ((clientObject.id + "_") + "chargingPart3"), ((clientObject.id + "_") + "shot"), "");
            }
            returned = terminatorSFXModels[clientObject.id];
            if (returned == null)
            {
                throw (new Error(("пизда бачок " + clientObject.id)));
            }
            return (returned);
        }
        public static function getSmokySFX(clientObject:ClientObject, ownerTank:ClientObject):SmokySFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            var returnObject:SmokySFXModel;
            if (smokySFXModels == null)
            {
                smokySFXModels = new Dictionary();
            }
            if (smokySFXModels[shotEffectId] == null)
            {
                smokySFXModels[shotEffectId] = new SmokySFXModel();
            }
            smokySFXModels[shotEffectId].initObject(clientObject, (clientObject.id + "_explosion"), (clientObject.id + "_explosion_sound"), (clientObject.id + "_shot"), (clientObject.id + "_shot_sound"), ownerTank);
            returnObject = smokySFXModels[shotEffectId];
            return (returnObject);
        }
        public static function getFlamethrowerSFX(clientObject:ClientObject, ownerTank:ClientObject):FlamethrowerSFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            if (flamethrowerSFXModels == null)
            {
                flamethrowerSFXModels = new Dictionary();
            }
            if (flamethrowerSFXModels[shotEffectId] == null)
            {
                flamethrowerSFXModels[shotEffectId] = new FlamethrowerSFXModel();
            }
            flamethrowerSFXModels[shotEffectId].initObject(clientObject, (shotEffectId + "_fire"), "flamethrower_sound", ownerTank);
            flamethrowerSFXModels[shotEffectId].objectLoaded(clientObject);
            flamethrowerSFXModels[shotEffectId].initFlameThrower(clientObject, ownerTank);
            return (flamethrowerSFXModels[shotEffectId]);
        }
        public static function getTwinsSFX(clientObject:ClientObject, ownerTank:ClientObject):PlasmaSFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            if (twinsSFXModels == null)
            {
                twinsSFXModels = new Dictionary();
            }
            if (twinsSFXModels[shotEffectId] == null)
            {
                twinsSFXModels[shotEffectId] = new PlasmaSFXModel();
            }
            twinsSFXModels[shotEffectId].initObject(clientObject, "twins_explosionSound", (shotEffectId + "_explosionTexture"), (shotEffectId + "_plasmaTexture"), "twins_shotSound", (shotEffectId + "_shotTexture"), ownerTank);
            return (twinsSFXModels[shotEffectId]);
        }
        public static function getIsidaSFX(clientObject:ClientObject, ownerTank:ClientObject):HealingGunSFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            if (isidaSFXModel == null)
            {
                isidaSFXModel = new HealingGunSFXModel();
                Main.osgi.registerService(IHealingSFXModelBase, isidaSFXModel);
            }
            isidaSFXModel.initObject(clientObject, (shotEffectId + "_damagingRayId"), "damagingSoundId", (shotEffectId + "_damagingTargetBallId"), (shotEffectId + "_damagingWeaponBallId"), (shotEffectId + "_healingRayId"), "healingSoundId", (shotEffectId + "_healingTargetBallId"), (shotEffectId + "_healingWeaponBallId"), "idleSoundId", (shotEffectId + "_idleWeaponBallId"));
            return (isidaSFXModel);
        }
        public static function getThunderSFX(clientObject:ClientObject, ownerTank:ClientObject):ThunderSFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            if (thunderSFXModels == null)
            {
                thunderSFXModels = new ThunderSFXModel();
            }
            thunderSFXModels.initObject(clientObject, (shotEffectId + "_explosionResourceId"), "thunder_explosionSoundResourceId", (clientObject.id + "_shotResourceId"), "thunder_shotSoundResourceId");
            return (thunderSFXModels);
        }
        public static function getHWThunderSFX(clientObject:ClientObject):HWThunderSFXModel
        {
            if (hwthunderSFXModels == null)
            {
                hwthunderSFXModels = new HWThunderSFXModel();
            }
            hwthunderSFXModels.initObject(clientObject, (clientObject.id + "_explosionResourceId"), "hwthunder_explosionSoundResourceId", (clientObject.id + "_shotResourceId"), "hwthunder_shotSoundResourceId");
            return (hwthunderSFXModels);
        }
        public static function getFrezeeSFXModel(clientObject:ClientObject, ownerTank:ClientObject):FreezeSFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            if (frezeeSFXModels == null)
            {
                frezeeSFXModels = new FreezeSFXModel();
            }
            frezeeSFXModels.initObject(clientObject, 17, (shotEffectId + "_particleTextureResourceId"), (shotEffectId + "_planeTextureResourceId"), "frezee_sound", ownerTank);
            return (frezeeSFXModels);
        }
        public static function getRicochetSFXModel(clientObject:ClientObject, ownerTank:ClientObject):RicochetSFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            if (ricochetSFXModels == null)
            {
                ricochetSFXModels = new RicochetSFXModel();
            }
            ricochetSFXModels.initObject(clientObject, (shotEffectId + "_bumpFlashTextureId"), "ricochet_explosionSoundId", shotEffectId + "_explosionTextureId", "ricochetSoundId", shotEffectId + "_shotFlashTextureId", "ricochet_shotSoundId", shotEffectId + "_shotTextureId", shotEffectId + "_tailTrailTextureId", ownerTank);
            return (ricochetSFXModels);
        }
        public static function getPumpkingunSFXModel(clientObject:ClientObject):PumpkingunSFXModel
        {
            if (pumpkingunSFXModels == null)
            {
                pumpkingunSFXModels = new PumpkingunSFXModel();
            }
            pumpkingunSFXModels.initObject(clientObject, (clientObject.id + "_bumpFlashTextureId"), "pumpkingun_explosionSoundId", (clientObject.id + "_explosionTextureId"), "pumpkingunSoundId", (clientObject.id + "_shotFlashTextureId"), "pumpkingun_shotSoundId", (clientObject.id + "_shotTextureId"), (clientObject.id + "_tailTrailTextureId"));
            return (pumpkingunSFXModels);
        }
        public static function getShaftSFX(clientObject:ClientObject, ownerTank:ClientObject):ShaftSFXModel
        {
            var shotEffectId:String = String(ownerTank.getParams(ShotEffect));
            var returnObject:ShaftSFXModel;
            if (shaftSFXModel == null)
            {
                shaftSFXModel = new Dictionary();
            }
            if (shaftSFXModel[shotEffectId] == null)
            {
                shaftSFXModel[shotEffectId] = new ShaftSFXModel();
            }
            shaftSFXModel[shotEffectId].initObject(clientObject, "shaft_zoomModeSound", "shaft_targetingSound", (shotEffectId + "_explosionTexture"), (shotEffectId + "_trail"), (shotEffectId + "_shot"), ownerTank);
            returnObject = shaftSFXModel[shotEffectId];
            return (returnObject);
        }
        public static function getObjectFor(id:String):ClientObject
        {
            if (turretObjects[id] == null)
            {
                turretObjects[id] = initObject(id);
            }
            return (turretObjects[id]);
        }
        public static function getSnowmanSFX(clientObject:ClientObject):SnowmanSFXModel
        {
            if (snowmanSFXModels == null)
            {
                snowmanSFXModels = new Dictionary();
            }
            if (snowmanSFXModels[clientObject.id] == null)
            {
                snowmanSFXModels[clientObject.id] = new SnowmanSFXModel();
                snowmanSFXModels[clientObject.id].initObject(clientObject, "snowman_shotExplosion", (clientObject.id + "_fire"), (clientObject.id + "_snow"), "snowman_shotSound", (clientObject.id + "_snow"));
            }
            return (snowmanSFXModels[clientObject.id]);
        }
        public static function getCommonShotSFX(turret:ClientObject, owner:ClientObject):ICommonShootSFX
        {
            var returnObject:ICommonShootSFX;
            var id:String = turret.id.split("_")[0];
            switch (id)
            {
                case "smoky":
                    returnObject = getSmokySFX(turret, owner);
                    break;
                case "smokyxt":
                    returnObject = getSmokySFX(turret, owner);
                    break;
                case "twins":
                    returnObject = getTwinsSFX(turret, owner);
                    break;
                case "twinsxt":
                    returnObject = getTwinsSFX(turret, owner);
                    break;
                case "shaft":
                    break;
                case "snowman":
                    returnObject = getSnowmanSFX(turret);
            }
            return (returnObject);
        }
        private static function initObject(id:String):ClientObject
        {
            var obj:ClientObject = new ClientObject(id, new ClientClass(id, null, id, null), id, null);
            return (obj);
        }
        public static function destroy():void
        {
            isidaSFXModel = null;
            twinsSFXModels = null;
            flamethrowerSFXModels = null;
            smokySFXModels = null;
            railgunSFXModels = null;
            thunderSFXModels = null;
            ricochetSFXModels = null;
            frezeeSFXModels = null;
            shaftSFXModel = null;
            snowmanSFXModels = null;
        }

    }
} // package scpacker.tanks