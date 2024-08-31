// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.test.spectator.SpectatorBonusRegionController

package logic.test.spectator
{
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;

    public class SpectatorBonusRegionController implements KeyboardHandler
    {

        [Inject]
        public static var bonusRegionService:Object;

        public function handleKeyDown(param1:KeyboardEvent):void
        {
            if (param1.keyCode == Keyboard.QUOTE)
            {
            }
        }
        public function handleKeyUp(param1:KeyboardEvent):void
        {
        }

    }
} // package scpacker.test.spectator