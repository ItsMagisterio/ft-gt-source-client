package platform.clients.fp10.libraries.alternativapartners.models.socialnetworkparameters
{
   [ModelInterface]
   public interface SocialNetworkParameters
   {

      function hasOwnPaymentSystem():Boolean;

      function hasSocialFunction():Boolean;

      function hasAccountBinding():Boolean;

      function canOpenRatings():Boolean;

      function hasPaymentAction():Boolean;

      function getFailedRedirectUrl():String;
   }
}
