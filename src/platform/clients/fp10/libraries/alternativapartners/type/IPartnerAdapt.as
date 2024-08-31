package platform.clients.fp10.libraries.alternativapartners.type
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class IPartnerAdapt implements platform.clients.fp10.libraries.alternativapartners.type.IPartner
   {

      private var object:IGameObject;

      private var impl:platform.clients.fp10.libraries.alternativapartners.type.IPartner;

      public function IPartnerAdapt(param1:IGameObject, param2:platform.clients.fp10.libraries.alternativapartners.type.IPartner)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function getLoginParameters(param1:IParametersListener):void
      {
         var listener:IParametersListener = param1;
         try
         {
            Model.object = this.object;
            this.impl.getLoginParameters(listener);
         }
         finally
         {
            Model.popObject();
         }
      }

      public function paymentAction():void
      {
         try
         {
            Model.object = this.object;
            this.impl.paymentAction();
         }
         finally
         {
            Model.popObject();
         }
      }
   }
}
