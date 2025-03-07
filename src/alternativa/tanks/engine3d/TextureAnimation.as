﻿package alternativa.tanks.engine3d
{
    import alternativa.engine3d.materials.TextureMaterial;
    import __AS3__.vec.Vector;

    public class TextureAnimation
    {

        public var material:TextureMaterial;
        public var frames:Vector.<UVFrame>;
        public var fps:Number;

        public function TextureAnimation(param1:TextureMaterial, param2:Vector.<UVFrame>, param3:Number = 0)
        {
            this.material = param1;
            this.frames = param2;
            this.fps = param3;
        }
    }
}
