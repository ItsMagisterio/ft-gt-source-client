package alternativa.tanks.models.battlefield
{
    public interface IUserStat
    {

        function getUserName(_arg_1:String):String;
        function getUserRank(_arg_1:String):int;
        function addUserStatListener(_arg_1:IUserStatListener):void;
        function removeUserStatListener(_arg_1:IUserStatListener):void;

    }
}
