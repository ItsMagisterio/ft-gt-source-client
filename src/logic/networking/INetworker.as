// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.networking.INetworker

package logic.networking
{
    import flash.events.Event;

    public interface INetworker
    {

        function connect(_arg_1:String, _arg_2:int):void;
        function addEventListener(_arg_1:INetworkListener):void;
        function onConnected(_arg_1:Event):void;
        function onDataSocket(_arg_1:Event):void;
        function onCloseConnecting(_arg_1:Event):void;
        function ioError(_arg_1:Event):void;
        function securityError(_arg_1:Event):void;

    }
} // package scpacker.networking