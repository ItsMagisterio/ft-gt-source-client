package alternativa.model
{
    import alternativa.types.Long;

    public interface IResourceLoadListener
    {

        function resourceLoaded(_arg_1:Object):void;
        function resourceUnloaded(_arg_1:Long):void;

    }
}
