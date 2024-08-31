package alternativa.tanks.model.garage.passtoshop
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class PassToShopServiceAdapt implements alternativa.tanks.model.garage.passtoshop.PassToShopService
   {

      private var object:IGameObject;

      private var impl:alternativa.tanks.model.garage.passtoshop.PassToShopService;

      public function PassToShopServiceAdapt(param1:IGameObject, param2:alternativa.tanks.model.garage.passtoshop.PassToShopService)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function isPassToShopEnabled():Boolean
      {
         var result:Boolean = false;
         try
         {
            Model.object = this.object;
            result = Boolean(this.impl.isPassToShopEnabled());
         }
         finally
         {
            Model.popObject();
         }
         return result;
      }
   }
}
