package alternativa.tanks.camera.controllers.spectator
{
   public class MovementMethods
   {

      private var methods:Vector.<MovementMethod>;

      private var currentMethodIndex:int;

      public function MovementMethods(_arg_1:Vector.<MovementMethod>)
      {
         super();
         this.methods = _arg_1;
      }

      public function getMethod():MovementMethod
      {
         return this.methods[this.currentMethodIndex];
      }

      public function selectNextMethod():void
      {
         this.currentMethodIndex = (this.currentMethodIndex + 1) % this.methods.length;
      }
   }
}
