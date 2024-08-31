package alternativa.tanks.camera.controllers.spectator
{
   import alternativa.tanks.utils.BitMask;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;

   public class UserInputImpl implements UserInput, KeyboardHandler
   {

      public static const BIT_FORWARD:int = 0;

      public static const BIT_BACK:int = 1;

      public static const BIT_LEFT:int = 2;

      public static const BIT_RIGHT:int = 3;

      public static const BIT_UP:int = 4;

      public static const BIT_DOWN:int = 5;

      public static const BIT_ACCELERATION:int = 6;

      public static const BIT_YAW_LEFT:int = 7;

      public static const BIT_YAW_RIGHT:int = 8;

      public static const BIT_PITCH_UP:int = 9;

      public static const BIT_PITCH_DOWN:int = 10;

      private static const ROTATION_MASK:int = 1920;

      private var keyMap:Dictionary;

      private var controlBits:BitMask;

      public function UserInputImpl()
      {
         keyMap = new Dictionary();
         controlBits = new BitMask(0);
         super();
         this.keyMap[87] = 0;
         this.keyMap[83] = 1;
         this.keyMap[65] = 2;
         this.keyMap[68] = 3;
         this.keyMap[81] = 5;
         this.keyMap[69] = 4;
         this.keyMap[16] = 6;
      }

      public function getForwardDirection():int
      {
         return this.getDirection(0, 1);
      }

      public function getSideDirection():int
      {
         return this.getDirection(3, 2);
      }

      public function getVerticalDirection():int
      {
         return this.getDirection(4, 5);
      }

      public function isAccelerated():Boolean
      {
         return this.controlBits.getBitValue(6) == 1;
      }

      public function handleKeyDown(_arg_1:KeyboardEvent):void
      {
         if (this.keyMap[_arg_1.keyCode] != null)
         {
            this.controlBits.setBit(this.keyMap[_arg_1.keyCode]);
         }
      }

      public function handleKeyUp(_arg_1:KeyboardEvent):void
      {
         if (this.keyMap[_arg_1.keyCode] != null)
         {
            this.controlBits.clearBit(this.keyMap[_arg_1.keyCode]);
         }
      }

      public function getYawDirection():int
      {
         return this.getDirection(7, 8);
      }

      public function getPitchDirection():int
      {
         return this.getDirection(9, 10);
      }

      public function isRotating():Boolean
      {
         return this.controlBits.hasAnyBit(1920);
      }

      private function getDirection(_arg_1:int, _arg_2:int):int
      {
         return this.controlBits.getBitValue(_arg_1) - this.controlBits.getBitValue(_arg_2);
      }

      public function reset():void
      {
         this.controlBits.clear();
      }
   }
}
