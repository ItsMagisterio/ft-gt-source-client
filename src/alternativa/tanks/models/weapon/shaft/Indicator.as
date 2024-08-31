// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.shaft.Indicator

package alternativa.tanks.models.weapon.shaft
{
    import flash.display.BitmapData;
    import alternativa.object.ClientObject;

    public class Indicator
    {

        private static const aim_m0:Class = Indicator_aim_m0;
        private static const aim_m1:Class = Indicator_aim_m1;
        private static const aim_m2:Class = Indicator_aim_m2;
        private static const aim_m3:Class = Indicator_aim_m3;
        private static var aimM0:BitmapData = new aim_m0().bitmapData;
        private static var aimM1:BitmapData = new aim_m1().bitmapData;
        private static var aimM2:BitmapData = new aim_m2().bitmapData;
        private static var aimM3:BitmapData = new aim_m3().bitmapData;

        public static function getIndicator(turret:ClientObject):BitmapData
        {
            switch (turret.id)
            {
                case "shaft_m0":
                    return (aimM0);
                case "shaft_m1":
                    return (aimM1);
                case "shaft_m2":
                    return (aimM2);
                case "shaft_m3":
                    return (aimM3);
                default:
                    return (aimM0);
            }
        }

    }
} // package alternativa.tanks.models.weapon.shaft