package alternativa.service
{
    import alternativa.register.ClientClass;
    import flash.utils.Dictionary;

    public interface IClassService
    {

        function createClass(_arg_1:String, _arg_2:ClientClass, _arg_3:String, _arg_4:Array, _arg_5:Array):ClientClass;
        function destroyClass(_arg_1:String):void;
        function getClass(_arg_1:String):ClientClass;
        function get classes():Dictionary;
        function get classList():Array;

    }
}
