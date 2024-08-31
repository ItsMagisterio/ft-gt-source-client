package alternativa.service
{
    import alternativa.register.SpaceInfo;
    import flash.utils.Dictionary;
    import alternativa.types.Long;

    public interface ISpaceService
    {

        function addSpace(_arg_1:SpaceInfo):void;
        function removeSpace(_arg_1:SpaceInfo):void;
        function get spaces():Dictionary;
        function get spaceList():Array;
        function getSpaceByObjectId(_arg_1:String):SpaceInfo;
        function setIdForSpace(_arg_1:SpaceInfo, _arg_2:Long):void;

    }
}
