package platform.clients.fp10.libraries.alternativapartners.models.socialnetworkparameters
{
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.type.IGameObject;

   public class SocialNetworkParametersAdapt implements platform.clients.fp10.libraries.alternativapartners.models.socialnetworkparameters.SocialNetworkParameters
   {

      private var object:IGameObject;

      private var impl:platform.clients.fp10.libraries.alternativapartners.models.socialnetworkparameters.SocialNetworkParameters;

      public function SocialNetworkParametersAdapt(param1:IGameObject, param2:platform.clients.fp10.libraries.alternativapartners.models.socialnetworkparameters.SocialNetworkParameters)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }

      public function hasOwnPaymentSystem():Boolean
      {
         var result:Boolean = false;
         try
         {
            Model.object = this.object;
            result = Boolean(this.impl.hasOwnPaymentSystem());
         }
         finally
         {
            Model.popObject();
         }
         return result;
      }

      public function hasSocialFunction():Boolean
      {
         var result:Boolean = false;
         try
         {
            Model.object = this.object;
            result = Boolean(this.impl.hasSocialFunction());
         }
         finally
         {
            Model.popObject();
         }
         return result;
      }

      public function hasAccountBinding():Boolean
      {
         var result:Boolean = false;
         try
         {
            Model.object = this.object;
            result = Boolean(this.impl.hasAccountBinding());
         }
         finally
         {
            Model.popObject();
         }
         return result;
      }

      public function canOpenRatings():Boolean
      {
         var result:Boolean = false;
         try
         {
            Model.object = this.object;
            result = Boolean(this.impl.canOpenRatings());
         }
         finally
         {
            Model.popObject();
         }
         return result;
      }

      public function hasPaymentAction():Boolean
      {
         var result:Boolean = false;
         try
         {
            Model.object = this.object;
            result = Boolean(this.impl.hasPaymentAction());
         }
         finally
         {
            Model.popObject();
         }
         return result;
      }

      public function getFailedRedirectUrl():String
      {
         var result:String = null;
         try
         {
            Model.object = this.object;
            result = String(this.impl.getFailedRedirectUrl());
         }
         finally
         {
            Model.popObject();
         }
         return result;
      }
   }
}
