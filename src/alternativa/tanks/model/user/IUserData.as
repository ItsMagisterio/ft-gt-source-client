package alternativa.tanks.model.user
{
    public interface IUserData
    {

        function get userId():Number;
        function get userName():String;
        function get userRank():Number;
        function get userEmail():String;
        function get isMailConfirmed():Boolean;
    }
}
