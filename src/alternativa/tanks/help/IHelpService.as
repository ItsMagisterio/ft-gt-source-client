package alternativa.tanks.help
{
    import flash.text.TextFormat;

    public interface IHelpService
    {

        function registerHelper(_arg_1:String, _arg_2:int, _arg_3:Helper, _arg_4:Boolean):void;
        function unregisterHelper(_arg_1:String, _arg_2:int):void;
        function showHelper(_arg_1:String, _arg_2:int, _arg_3:Boolean = false):void;
        function hideHelper(_arg_1:String, _arg_2:int):void;
        function showHelp():void;
        function hideHelp():void;
        function setHelperTextFormat(_arg_1:TextFormat):void;

    }
}
