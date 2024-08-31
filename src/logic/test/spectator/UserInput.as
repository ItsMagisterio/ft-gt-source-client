// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.test.spectator.UserInput

package logic.test.spectator
{
    public interface UserInput
    {

        function getForwardDirection():int;
        function getSideDirection():int;
        function getVerticalDirection():int;
        function isAcceleratied():Boolean;
        function getYawDirection():int;
        function getPitchDirection():int;
        function isRotating():Boolean;
        function reset():void;

    }
} // package scpacker.test.spectator