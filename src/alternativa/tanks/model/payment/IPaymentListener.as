package alternativa.tanks.model.payment
{
    public interface IPaymentListener
    {

        function setInitData(_arg_1:Array, _arg_2:Array, _arg_3:String, _arg_4:int, _arg_5:String):void;
        function setOperators(_arg_1:String, _arg_2:Array):void;
        function setNumbers(_arg_1:int, _arg_2:Array):void;

    }
}
