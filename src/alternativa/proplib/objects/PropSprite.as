﻿package alternativa.proplib.objects
{
    import alternativa.utils.textureutils.TextureByteData;
    import alternativa.engine3d.objects.Sprite3D;

    public class PropSprite extends PropObject
    {

        public var textureData:TextureByteData;
        public var scale:Number;

        public function PropSprite(textureData:TextureByteData, originX:Number = 0.5, originY:Number = 0.5, scale:Number = 1)
        {
            super(PropObjectType.SPRITE);
            this.textureData = textureData;
            this.scale = scale;
            var sprite:Sprite3D = new Sprite3D(1, 1);
            sprite.originX = originX;
            sprite.originY = originY;
            object = sprite;
        }
        override public function traceProp():void
        {
            super.traceProp();
        }
        public function remove():*
        {
            var s:Sprite3D = (object as Sprite3D);
            // s.destroy();
            s = null;
        }

    }
}
