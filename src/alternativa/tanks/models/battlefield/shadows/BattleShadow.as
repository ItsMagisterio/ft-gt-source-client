﻿package alternativa.tanks.models.battlefield.shadows
{
    import alternativa.tanks.models.battlefield.BattleView3D;

    public class BattleShadow
    {

        private var view:BattleView3D;

        public function BattleShadow(view:BattleView3D)
        {
            this.view = view;
        }
        public function on():void
        {
            this.view.camera.softTransparency = true;
            this.view.camera.softTransparencyStrength = 1;
        }
        public function off():void
        {
            this.view.camera.useShadowMap = false;
            this.view.camera.useLight = false;
        }

    }
}
