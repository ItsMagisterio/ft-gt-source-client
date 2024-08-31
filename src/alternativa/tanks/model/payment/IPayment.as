package alternativa.tanks.model.payment
{
    public interface IPayment
    {

        function getData():void;
        function getOperatorsList(_arg_1:String):void;
        function getNumbersList(_arg_1:int):void;
        function get accountId():String;
        function get projectId():int;
        function get formId():String;
        function get currentLocaleCurrency():String;

    }
}
