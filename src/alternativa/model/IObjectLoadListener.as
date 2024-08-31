package alternativa.model
{
    import alternativa.object.ClientObject;

    public interface IObjectLoadListener
    {

        function objectLoaded(_arg_1:ClientObject):void;
        function objectUnloaded(_arg_1:ClientObject):void;

    }
}
