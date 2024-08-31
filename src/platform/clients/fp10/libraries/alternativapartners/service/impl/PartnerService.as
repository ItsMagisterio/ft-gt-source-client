package platform.clients.fp10.libraries.alternativapartners.service.impl
{
   import alternativa.osgi.service.launcherparams.ILauncherParams;
   import alternativa.osgi.service.logging.LogService;
   import platform.client.fp10.core.service.address.AddressService;
   import platform.client.fp10.core.type.IGameObject;
   import platform.clients.fp10.libraries.alternativapartners.models.socialnetworkparameters.SocialNetworkParameters;
   import platform.clients.fp10.libraries.alternativapartners.service.IPartnerService;
   import platform.clients.fp10.libraries.alternativapartners.type.IPartner;

   public class PartnerService implements IPartnerService
   {

      [Inject]
      public static var addressService:AddressService;

      [Inject]
      public static var log:LogService;

      [Inject]
      public static var paramsService:ILauncherParams;

      private var _partner:IPartner;

      private var _hasOwnPaymentSystem:Boolean = false;

      private var _hasSocialFunction:Boolean = false;

      private var _hasAccountBinding:Boolean = false;

      private var _canOpenRating:Boolean = false;

      private var _hasPaymentAction:Boolean = false;

      private var _failedRedirectUrl:String = "";

      public function PartnerService()
      {
         super();
      }

      public function isRunningInsidePartnerEnvironment():Boolean
      {
         var _loc1_:String = this.getEnvironmentPartnerId();
         return Boolean(_loc1_);
      }

      public function getEnvironmentPartnerId():String
      {
         var _loc1_:String = addressService.getQueryParameter("partnerId");
         if (!_loc1_)
         {
            _loc1_ = String(paramsService.getParameter("partnerId"));
            if (!_loc1_)
            {
               _loc1_ = "";
            }
         }
         return _loc1_.toLowerCase();
      }

      public function hasPaymentAction():Boolean
      {
         return this._hasPaymentAction;
      }

      public function makePaymentAction():void
      {
         if (Boolean(this._partner))
         {
            this._partner.paymentAction();
         }
      }

      public function hasOwnPaymentSystem():Boolean
      {
         return this._hasOwnPaymentSystem;
      }

      public function hasSocialFunction():Boolean
      {
         return this._hasSocialFunction;
      }

      public function getFailRedirectUrl():String
      {
         return this._failedRedirectUrl;
      }

      public function isExternalLoginAllowed():Boolean
      {
         return this._hasAccountBinding;
      }

      public function setPartner(param1:IGameObject):void
      {
         this._partner = IPartner(param1.adapt(IPartner));
         var _loc2_:SocialNetworkParameters = SocialNetworkParameters(param1.adapt(SocialNetworkParameters));
         this._hasOwnPaymentSystem = _loc2_.hasOwnPaymentSystem();
         this._hasSocialFunction = _loc2_.hasSocialFunction();
         this._hasAccountBinding = _loc2_.hasAccountBinding();
         this._canOpenRating = _loc2_.canOpenRatings();
         this._hasPaymentAction = _loc2_.hasPaymentAction();
         this._failedRedirectUrl = _loc2_.getFailedRedirectUrl();
      }

      public function hasRatings():Boolean
      {
         return this._canOpenRating;
      }

      public function isRunningInside(param1:String):Boolean
      {
         var _loc2_:String = this.getEnvironmentPartnerId();
         if (_loc2_ == null)
         {
            return null;
         }
         return _loc2_.toLocaleLowerCase() == param1.toLocaleLowerCase();
      }
   }
}
