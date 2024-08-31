package alternativa.tanks.model.panel
{
    public interface IPanel
    {

        function lock():void;
        function unlock():void;
        function get userName():String;
        function get rank():int;
        function get crystal():int;
        function partSelected(_arg_1:int):void;
        function blur():void;
        function unblur():void;
        function reloadGarage():void;
        function showIconQuest(param1:Boolean):void;
        function goToGarage():void;
        function goToPayment():void;
        function setInviteSendResult(_arg_1:Boolean, _arg_2:String):void;
        function _showMessage(_arg_1:String):void;
        function setIdNumberCheckResult(_arg_1:Boolean):void;

    }
}
