package platform.clients.fp10.libraries.alternativapartners.type
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class IPartnerEvents implements IPartner
   {

      private var object:IGameObject;

      private var impl:Vector.<Object>;

      public function IPartnerEvents(param1:IGameObject, param2:Vector.<Object>)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function getLoginParameters(param1:IParametersListener):void
      {
         var i:int = 0;
         var m:IPartner = null;
         var listener:IParametersListener = param1;
         try
         {
            Model.object = this.object;
            i = 0;
            while (i < this.impl.length)
            {
               m = IPartner(this.impl[i]);
               m.getLoginParameters(listener);
               i++;
            }
         }
         finally
         {
            Model.popObject();
         }
      }

      public function paymentAction():void
      {
         var i:int = 0;
         var m:IPartner = null;
         try
         {
            Model.object = this.object;
            i = 0;
            while (i < this.impl.length)
            {
               m = IPartner(this.impl[i]);
               m.paymentAction();
               i++;
            }
         }
         finally
         {
            Model.popObject();
         }
      }
   }
}
