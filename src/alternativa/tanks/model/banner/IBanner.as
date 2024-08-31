package alternativa.tanks.model.banner
{
    import alternativa.object.ClientObject;
    import flash.display.BitmapData;

    public interface IBanner
    {

        function getBannerBd(_arg_1:ClientObject):BitmapData;
        function getBannerURL(_arg_1:ClientObject):String;
        function click(_arg_1:ClientObject):void;

    }
}
