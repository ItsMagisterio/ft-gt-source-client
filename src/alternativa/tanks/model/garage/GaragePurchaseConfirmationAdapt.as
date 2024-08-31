package alternativa.tanks.model.garage
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class GaragePurchaseConfirmationAdapt implements alternativa.tanks.model.garage.GaragePurchaseConfirmation
   {

      private var object:IGameObject;

      private var impl:alternativa.tanks.model.garage.GaragePurchaseConfirmation;

      public function GaragePurchaseConfirmationAdapt(param1:IGameObject, param2:alternativa.tanks.model.garage.GaragePurchaseConfirmation)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function showConfirmationAlert(param1:int):void
      {
         var cost:int = param1;
         try
         {
            Model.object = this.object;
            this.impl.showConfirmationAlert(cost);
         }
         finally
         {
            Model.popObject();
         }
      }
   }
}
