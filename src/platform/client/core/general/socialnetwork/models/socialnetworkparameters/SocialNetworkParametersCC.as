package platform.client.core.general.socialnetwork.models.socialnetworkparameters
{
   public class SocialNetworkParametersCC
   {

      private var _canOpenExternalLinks:Boolean;

      private var _failedRedirectUrl:String;

      private var _hasAccountBinding:Boolean;

      private var _hasClientPaymentAction:Boolean;

      private var _hasOwnPaymentSystem:Boolean;

      private var _hasSocialFunction:Boolean;

      public function SocialNetworkParametersCC(param1:Boolean = false, param2:String = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this._canOpenExternalLinks = param1;
         this._failedRedirectUrl = param2;
         this._hasAccountBinding = param3;
         this._hasClientPaymentAction = param4;
         this._hasOwnPaymentSystem = param5;
         this._hasSocialFunction = param6;
      }

      public function get canOpenExternalLinks():Boolean
      {
         return this._canOpenExternalLinks;
      }

      public function set canOpenExternalLinks(param1:Boolean):void
      {
         this._canOpenExternalLinks = param1;
      }

      public function get failedRedirectUrl():String
      {
         return this._failedRedirectUrl;
      }

      public function set failedRedirectUrl(param1:String):void
      {
         this._failedRedirectUrl = param1;
      }

      public function get hasAccountBinding():Boolean
      {
         return this._hasAccountBinding;
      }

      public function set hasAccountBinding(param1:Boolean):void
      {
         this._hasAccountBinding = param1;
      }

      public function get hasClientPaymentAction():Boolean
      {
         return this._hasClientPaymentAction;
      }

      public function set hasClientPaymentAction(param1:Boolean):void
      {
         this._hasClientPaymentAction = param1;
      }

      public function get hasOwnPaymentSystem():Boolean
      {
         return this._hasOwnPaymentSystem;
      }

      public function set hasOwnPaymentSystem(param1:Boolean):void
      {
         this._hasOwnPaymentSystem = param1;
      }

      public function get hasSocialFunction():Boolean
      {
         return this._hasSocialFunction;
      }

      public function set hasSocialFunction(param1:Boolean):void
      {
         this._hasSocialFunction = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "SocialNetworkParametersCC [";
         _loc1_ += "canOpenExternalLinks = " + this.canOpenExternalLinks + " ";
         _loc1_ += "failedRedirectUrl = " + this.failedRedirectUrl + " ";
         _loc1_ += "hasAccountBinding = " + this.hasAccountBinding + " ";
         _loc1_ += "hasClientPaymentAction = " + this.hasClientPaymentAction + " ";
         _loc1_ += "hasOwnPaymentSystem = " + this.hasOwnPaymentSystem + " ";
         _loc1_ += "hasSocialFunction = " + this.hasSocialFunction + " ";
         return _loc1_ + "]";
      }
   }
}
