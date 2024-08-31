package projects.tanks.client.battlefield.models.tankparts.sfx.lighting.entity
{
   public class LightingSFXEntity
   {

      private var _effects:Vector.<LightingEffectEntity>;

      public function LightingSFXEntity(param1:Vector.<LightingEffectEntity> = null)
      {
         super();
         this._effects = param1;
      }

      public function get effects():Vector.<LightingEffectEntity>
      {
         return this._effects;
      }

      public function set effects(param1:Vector.<LightingEffectEntity>):void
      {
         this._effects = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "LightingSFXEntity [";
         _loc1_ += "effects = " + this.effects + " ";
         return _loc1_ + "]";
      }
   }
}
