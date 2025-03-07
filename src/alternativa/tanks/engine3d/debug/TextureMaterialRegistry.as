﻿package alternativa.tanks.engine3d.debug
{
    import alternativa.tanks.engine3d.ITextureMaterialRegistry;
    import alternativa.tanks.engine3d.TanksTextureMaterial;
    import logic.resource.images.ImageResource;
    import flash.display.BitmapData;
    import alternativa.tanks.materials.AnimatedPaintMaterial;
    import alternativa.tanks.materials.PaintMaterial;
    import alternativa.tanks.engine3d.MaterialType;
    import alternativa.engine3d.materials.TextureMaterial;

    public class TextureMaterialRegistry implements ITextureMaterialRegistry
    {

        private var mapMaterial:TanksTextureMaterial;
        private var tankMaterial:TanksTextureMaterial;
        private var effectMaterial:TanksTextureMaterial;

        public function TextureMaterialRegistry()
        {
            this.mapMaterial = new TanksTextureMaterial(new DebugTexture(24, 6, 12615551, 0x660000), false, false, 0, 0);
            this.tankMaterial = new TanksTextureMaterial(new DebugTexture(24, 12, 8372351, 0x6600), false, false, 0, 0);
            this.effectMaterial = new TanksTextureMaterial(new DebugTexture(24, 6, 8355776, 102), false, false, 0, 0);
        }
        public function getAnimatedPaint(imageResource:ImageResource, lightmap:BitmapData, details:BitmapData, objId:String):AnimatedPaintMaterial
        {
            return (null);
        }
        public function getPaint1(imageResource:ImageResource, lightmap:BitmapData, details:BitmapData, objId:String):PaintMaterial
        {
            return (null);
        }
        public function set timerInterval(value:int):void
        {
        }
        public function set resoluion(value:Number):void
        {
        }
        public function get useMipMapping():Boolean
        {
            return (false);
        }
        public function set useMipMapping(value:Boolean):void
        {
        }
        public function getMaterial(materialType:MaterialType, texture:BitmapData, mipMapResolution:Number, disposeMainTexure:Boolean = false):TextureMaterial
        {
            switch (materialType)
            {
                case MaterialType.EFFECT:
                    return (this.effectMaterial);
                case MaterialType.MAP:
                    return (this.mapMaterial);
                case MaterialType.TANK:
                    return (this.tankMaterial);
                default:
                    return (null);
            }
        }
        public function clear():void
        {
        }
        public function getDump():String
        {
            return ("");
        }
        public function disposeMaterial(material:TextureMaterial):void
        {
        }

    }
}
