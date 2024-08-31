package alternativa.tanks.service.money
{
    public interface IMoneyService
    {

        function addListener(_arg_1:IMoneyListener):void;
        function removeListener(_arg_1:IMoneyListener):void;
        function get crystal():int;

    }
}
