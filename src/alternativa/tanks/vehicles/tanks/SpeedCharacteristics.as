package alternativa.tanks.vehicles.tanks
{
   import alternativa.tanks.vehicles.tanks.EncryptedNumber.EncryptedNumber;
   import alternativa.tanks.vehicles.tanks.EncryptedNumber.EncryptedNumberImpl;

   public class SpeedCharacteristics
   {

      private var _maxSpeed:EncryptedNumber;

      private var _acceleration:EncryptedNumber;

      private var _reverseAcceleration:EncryptedNumber;

      private var _deceleration:EncryptedNumber;

      private var _turnMaxSpeed:EncryptedNumber;

      private var _turnAcceleration:EncryptedNumber;

      private var _turnReverseAcceleration:EncryptedNumber;

      private var _turnDeceleration:EncryptedNumber;

      private var _sideAcceleration:EncryptedNumber;

      public function SpeedCharacteristics()
      {
         this._maxSpeed = new EncryptedNumberImpl();
         this._acceleration = new EncryptedNumberImpl();
         this._reverseAcceleration = new EncryptedNumberImpl();
         this._deceleration = new EncryptedNumberImpl();
         this._turnMaxSpeed = new EncryptedNumberImpl();
         this._turnAcceleration = new EncryptedNumberImpl();
         this._turnReverseAcceleration = new EncryptedNumberImpl();
         this._turnDeceleration = new EncryptedNumberImpl();
         this._sideAcceleration = new EncryptedNumberImpl();
         super();
      }

      public function get maxSpeed():Number
      {
         return this._maxSpeed.getNumber();
      }

      public function get acceleration():Number
      {
         return this._acceleration.getNumber();
      }

      public function get reverseAcceleration():Number
      {
         return this._reverseAcceleration.getNumber();
      }

      public function get deceleration():Number
      {
         return this._deceleration.getNumber();
      }

      public function get turnMaxSpeed():Number
      {
         return this._turnMaxSpeed.getNumber();
      }

      public function get turnAcceleration():Number
      {
         return this._turnAcceleration.getNumber();
      }

      public function get turnReverseAcceleration():Number
      {
         return this._turnReverseAcceleration.getNumber();
      }

      public function get turnDeceleration():Number
      {
         return this._turnDeceleration.getNumber();
      }

      public function get sideAcceleration():Number
      {
         return this._sideAcceleration.getNumber();
      }

      public function set maxSpeed(param1:Number):void
      {
         this._maxSpeed.setNumber(param1);
      }

      public function set acceleration(param1:Number):void
      {
         this._acceleration.setNumber(param1);
      }

      public function set reverseAcceleration(param1:Number):void
      {
         this._reverseAcceleration.setNumber(param1);
      }

      public function set deceleration(param1:Number):void
      {
         this._deceleration.setNumber(param1);
      }

      public function set turnMaxSpeed(param1:Number):void
      {
         this._turnMaxSpeed.setNumber(param1);
      }

      public function set turnAcceleration(param1:Number):void
      {
         this._turnAcceleration.setNumber(param1);
      }

      public function set turnReverseAcceleration(param1:Number):void
      {
         this._turnReverseAcceleration.setNumber(param1);
      }

      public function set turnDeceleration(param1:Number):void
      {
         this._turnDeceleration.setNumber(param1);
      }

      public function set sideAcceleration(param1:Number):void
      {
         this._sideAcceleration.setNumber(param1);
      }
   }
}
