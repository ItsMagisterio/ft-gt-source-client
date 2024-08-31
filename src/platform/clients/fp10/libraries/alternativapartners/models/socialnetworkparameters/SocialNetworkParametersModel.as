package platform.clients.fp10.libraries.alternativapartners.models.socialnetworkparameters
{
   import platform.client.core.general.socialnetwork.models.socialnetworkparameters.ISocialNetworkParametersModelBase;
   import platform.client.core.general.socialnetwork.models.socialnetworkparameters.SocialNetworkParametersModelBase;

   [ModelInfo]
   public class SocialNetworkParametersModel extends SocialNetworkParametersModelBase implements ISocialNetworkParametersModelBase, SocialNetworkParameters
   {

      public function SocialNetworkParametersModel()
      {
         super();
      }

      public function hasOwnPaymentSystem():Boolean
      {
         return getInitParam().hasOwnPaymentSystem;
      }

      public function hasSocialFunction():Boolean
      {
         return getInitParam().hasSocialFunction;
      }

      public function hasAccountBinding():Boolean
      {
         return getInitParam().hasAccountBinding;
      }

      public function canOpenRatings():Boolean
      {
         return getInitParam().canOpenExternalLinks;
      }

      public function hasPaymentAction():Boolean
      {
         return getInitParam().hasClientPaymentAction;
      }

      public function getFailedRedirectUrl():String
      {
         return getInitParam().failedRedirectUrl;
      }
   }
}
