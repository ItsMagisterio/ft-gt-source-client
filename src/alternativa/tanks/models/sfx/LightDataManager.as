package alternativa.tanks.models.sfx
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class LightDataManager
    {

        private static var data:Dictionary = new Dictionary();
        private static var colors:Dictionary = new Dictionary();

        public static function init(json_:String):void
        {
            var item:Object;
            var turretId:String;
            var animations:Vector.<LightingEffectRecord>;
            var anim:Object;
            var json:Object = JSON.parse(json_);
            var items:Array = json.data;
            for each (item in items)
            {
                if (item.turret.split("_")[0] == "bonus")
                {
                    colors[item.turret] = item.color;
                }
                else
                {
                    turretId = item.turret;
                    animations = new Vector.<LightingEffectRecord>();
                    for each (anim in item.animation)
                    {
                        animations.push(new LightingEffectRecord(anim.attenuationBegin, anim.attenuationEnd, anim.color, anim.intensity, anim.time));
                    }
                    data[turretId] = new LightAnimation(animations);
                }
            }
        }
        public static function getLightDataMuzzle(turretId:String):LightAnimation
        {
            return (data[(turretId + "_muzzle")]);
        }
        public static function getLightDataShot(turretId:String):LightAnimation
        {
            return (data[(turretId + "_shot")]);
        }
        public static function getLightDataExplosion(turretId:String):LightAnimation
        {
            return (data[(turretId + "_explosion")]);
        }
        public static function getLightData(turretId:String, effectName:String):LightAnimation
        {
            return (data[((turretId + "_") + effectName)]);
        }
        public static function getBonusLightColor(bonusId:String):uint
        {
            return (colors[bonusId]);
        }

    }
}
