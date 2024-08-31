package alternativa.tanks.model
{
    import logic.resource.images.ImageResource;

    public interface IGarage
    {

        function setHull(_arg_1:String):void;
        function setTurret(_arg_1:String):void;
        function setColorMap(_arg_1:ImageResource):void;

    }
}
