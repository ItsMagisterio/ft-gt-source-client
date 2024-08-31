﻿package alternativa.init
{
    import alternativa.osgi.bundle.IBundleActivator;
    import flash.text.Font;

    public class TanksFonts implements IBundleActivator
    {

        private static const Arabic:Class = TanksFonts_Arabic;
        private static const MyriadProB:Class = TanksFonts_MyriadProB;

        public static function init():void
        {
            Font.registerFont(MyriadProB);
            Font.registerFont(Arabic);
        }

        public function start(osgi:OSGi):void
        {
            Font.registerFont(MyriadProB);
            Font.registerFont(Arabic);
        }
        public function stop(osgi:OSGi):void
        {
        }

    }
}
