package alternativa.tanks.engine3d
{
    import logic.resource.images.ImageResource;
    import flash.display.BitmapData;
    import alternativa.tanks.materials.AnimatedPaintMaterial;
    import alternativa.tanks.materials.PaintMaterial;
    import alternativa.engine3d.materials.TextureMaterial;

    public interface ITextureMaterialRegistry
    {

        function getAnimatedPaint(_arg_1:ImageResource, _arg_2:BitmapData, _arg_3:BitmapData, _arg_4:String):AnimatedPaintMaterial;
        function getPaint1(_arg_1:ImageResource, _arg_2:BitmapData, _arg_3:BitmapData, _arg_4:String):PaintMaterial;
        function set resoluion(_arg_1:Number):void;
        function get useMipMapping():Boolean;
        function set useMipMapping(_arg_1:Boolean):void;
        function getMaterial(_arg_1:MaterialType, _arg_2:BitmapData, _arg_3:Number, _arg_4:Boolean = true):TextureMaterial;
        function clear():void;
        function getDump():String;
        function disposeMaterial(_arg_1:TextureMaterial):void;

    }
}
