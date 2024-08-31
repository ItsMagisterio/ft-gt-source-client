package alternativa.service
{
    import flash.events.Event;

    public interface IAddressService
    {

        function reload():void;
        function back():void;
        function forward():void;
        function up():void;
        function go(_arg_1:int):void;
        function href(_arg_1:String, _arg_2:String = "_self"):void;
        function popup(_arg_1:String, _arg_2:String = "popup", _arg_3:String = '""', _arg_4:String = ""):void;
        function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false):void;
        function removeEventListener(_arg_1:String, _arg_2:Function):void;
        function dispatchEvent(_arg_1:Event):Boolean;
        function hasEventListener(_arg_1:String):Boolean;
        function getBaseURL():String;
        function getStrict():Boolean;
        function setStrict(_arg_1:Boolean):void;
        function getHistory():Boolean;
        function setHistory(_arg_1:Boolean):void;
        function getTracker():String;
        function setTracker(_arg_1:String):void;
        function getTitle():String;
        function setTitle(_arg_1:String):void;
        function getStatus():String;
        function setStatus(_arg_1:String):void;
        function resetStatus():void;
        function getValue():String;
        function setValue(_arg_1:String):void;
        function getPath():String;
        function getPathNames():Array;
        function getQueryString():String;
        function getParameter(_arg_1:String):String;
        function getParameterNames():Array;

    }
}
