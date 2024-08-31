package alternativa.console
{
    public interface IConsole
    {

        function addToggleKey(_arg_1:uint, _arg_2:Boolean = false, _arg_3:Boolean = false, _arg_4:Boolean = false):void;
        function addLine(_arg_1:String):void;
        function clear():void;
        function dispose():void;
        function addVariable(_arg_1:ConsoleVar):void;
        function removeVariable(_arg_1:String):void;
        function addCommandHandler(_arg_1:String, _arg_2:Function):void;
        function removeCommandHandler(_arg_1:String):void;
        function getCommandList():Array;
        function getAlpha():Number;
        function setAlpha(_arg_1:Number):void;
        function getHeight():int;
        function setHeight(_arg_1:int):void;
        function setFontSize(_arg_1:int):void;
        function show():void;
        function hide():void;
        function hideDelayed(_arg_1:uint):void;
        function isDebugMode():Boolean;
        function getText():String;

    }
}
