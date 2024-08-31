package alternativa.tanks.model.shop.items.promo
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.shop.ShopWindow;
   import controls.TankWindowInner;
   import controls.ValidationIcon;
   import controls.base.DefaultButtonBase;
   import controls.base.LabelBase;
   import controls.base.TankInputBase;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import utils.tweener.TweenLite;
   import utils.tweener.core.SimpleTimeline;
   import utils.tweener.easing.Elastic;
   import flash.display.Sprite;
   import controls.TankInput;
   import com.gskinner.motion.easing.Linear;
   import controls.TankWindow;

   public class PromoCodeActivateForm extends TankWindow
   {

      public static const PROMO_CODE_PATTERN:String = "[a-z0-9A-Z]";

      public static const DESCRIPTION_HEIGHT:int = 82;

      public static const MARGIN:int = 8;

      [Inject]
      public static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;

      [Inject]
      public static var display:DisplayObjectContainer = Main.dialogsLayer;

      protected static const MAX_LENGTH:int = 50;

      protected static const BLOCK_LENGTH:int = 5;

      protected static const TWEEN_FORCE:int = 100;

      private var codeField:TankInputBase;

      private var sendButton:DefaultButtonBase;

      private var validationIcon:ValidationIcon;

      private var codeTween:SimpleTimeline;

      private var code:String = "";

      private var descriptionWindow:TankWindowInner;

      private var descriptionLabel:LabelBase;

      private var invalidCodeLabel:LabelBase;

      public function PromoCodeActivateForm()
      {
         this.descriptionWindow = new TankWindowInner(0, 0, TankWindowInner.GREEN);
         this.descriptionWindow.showBlink = true;
         addChild(this.descriptionWindow);
         this.descriptionLabel = this.createDescriptionLabel();
         this.descriptionWindow.addChild(this.descriptionLabel);
         this.codeField = this.createCodeField();
         addChild(this.codeField);
         this.sendButton = this.createSendButton();
         addChild(this.sendButton);
         this.validationIcon = this.createValidationIcon();
         addChild(this.validationIcon);
         this.invalidCodeLabel = this.createInvalidCodeLabel();
         addChild(this.invalidCodeLabel);
      }

      private function createDescriptionLabel():LabelBase
      {
         var _loc1_:LabelBase = new LabelBase();
         _loc1_.autoSize = TextFieldAutoSize.NONE;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.htmlText = "You can use Promo Codes to get Crystals, Premium Account time and garage items. These items will be added to your account instantly.";
         return _loc1_;
      }

      protected function createCodeField():TankInputBase
      {
         var _loc1_:TankInputBase = new TankInputBase();
         _loc1_.align = TextFormatAlign.CENTER;
         _loc1_.restrict = PROMO_CODE_PATTERN;
         return _loc1_;
      }

      protected function createSendButton():DefaultButtonBase
      {
         var _loc1_:DefaultButtonBase = new DefaultButtonBase();
         _loc1_.tabEnabled = false;
         _loc1_.enable = false;
         _loc1_.label = "Send";
         return _loc1_;
      }

      protected function createValidationIcon():ValidationIcon
      {
         var _loc1_:ValidationIcon = null;
         _loc1_ = new ValidationIcon();
         _loc1_.fadeTime = 0.2;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         return _loc1_;
      }

      protected function createInvalidCodeLabel():LabelBase
      {
         var _loc1_:LabelBase = new LabelBase();
         _loc1_.visible = false;
         _loc1_.text = "The promo code is invalid or already used.";
         return _loc1_;
      }

      private function onBackButtonClick(param1:Event):void
      {
         display.stage.focus = null;
      }

      private function getCodeTween():SimpleTimeline
      {
         if (!this.codeTween)
         {
            this.codeTween = new SimpleTimeline();
            this.codeTween.insert(TweenLite.to(this.codeField.textField, 0.2, {
                        "x": TWEEN_FORCE,
                        "ease": Linear.easeNone
                     }));
            this.codeTween.insert(TweenLite.to(this.codeField.textField, 0.2, {
                        "x": 0,
                        "ease": Linear.easeNone
                     }));
         }
         return this.codeTween;
      }

      private function textInputHandler(param1:TextEvent = null):void
      {
         this.getCodeTween().restart(true);
      }

      private function textEditHandler(param1:Event):void
      {
         var _loc7_:String = null;
         this.codeField.validValue = true;
         this.validationIcon.turnOff();
         this.invalidCodeLabel.visible = false;
         var _loc2_:String = "";
         var _loc3_:int = this.codeField.textField.length;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = _loc3_ - this.codeField.textField.selectionBeginIndex;
         this.code = "";
         while (_loc4_ < _loc3_)
         {
            _loc7_ = this.codeField.textField.text.charAt(_loc4_).toUpperCase();
            if (_loc7_ != "-")
            {
               this.code = this.code.concat(_loc7_);
               if (_loc3_ - _loc4_ > 1 && _loc2_.length - BLOCK_LENGTH + 1 >= 0 && (_loc2_.length - _loc5_ + 1) % BLOCK_LENGTH == 0)
               {
                  _loc7_ = _loc7_.concat("-");
                  _loc5_++;
               }
               _loc2_ = _loc2_.concat(_loc7_);
            }
            _loc4_++;
         }
         if (_loc2_.charAt(_loc2_.length - 1) == "-")
         {
            _loc2_ = _loc2_.substr(0, _loc2_.length - 1);
         }
         this.codeField.maxChars = MAX_LENGTH + _loc5_;
         this.codeField.textField.text = _loc2_;
         this.codeField.textField.setSelection(_loc2_.length - _loc6_, _loc2_.length - _loc6_);
         this.sendButton.enable = this.isValidPromoCode(this.code);
      }

      private function sendOnEnterHandler(param1:KeyboardEvent):void
      {
         if (param1.keyCode == Keyboard.ENTER)
         {
            this.sendClickHandler();
         }
      }

      protected function sendClickHandler(param1:MouseEvent = null):void
      {
         if (this.isValidPromoCode(this.code))
         {
            this.validationIcon.startProgress();
            this.sendButton.enable = false;
            this.codeField.enable = false;
            dispatchEvent(new SendPromoCodeEvent(this.getPromoCode()));
         }
         else
         {
            this.textInputHandler();
         }
      }

      public function render(param1:int, param2:int):void
      {
         super.width = param1;
         super.height = param2;
         this.getCodeTween().restart(true);
         this.sendButton.enable = this.isValidPromoCode(this.code);
         this.descriptionWindow.width = param1 - 2 * ShopWindow.WINDOW_PADDING;
         this.descriptionWindow.x = ShopWindow.WINDOW_PADDING;
         this.descriptionWindow.y = 12;
         this.descriptionWindow.height = DESCRIPTION_HEIGHT;
         this.descriptionLabel.width = param1 - 2 * ShopWindow.WINDOW_PADDING;
         this.descriptionLabel.height = DESCRIPTION_HEIGHT - 2 * ShopWindow.WINDOW_PADDING;
         this.descriptionLabel.x = this.descriptionLabel.y = ShopWindow.WINDOW_PADDING;
         var _loc3_:int = param2 - DESCRIPTION_HEIGHT;
         this.codeField.width = Math.max(this.codeField.textField.textWidth, int(param1 * 0.66));
         this.codeField.x = param1 - this.codeField.width - this.sendButton.width - MARGIN >> 1;
         this.codeField.y = (_loc3_ - this.codeField.height >> 1) + DESCRIPTION_HEIGHT;
         this.sendButton.x = this.codeField.x + this.codeField.width + MARGIN;
         this.sendButton.y = this.codeField.y;
         this.invalidCodeLabel.x = int(this.codeField.x + this.codeField.width / 2) - int(this.invalidCodeLabel.width / 2);
         this.invalidCodeLabel.y = int(this.codeField.y + this.codeField.height + MARGIN);
         var _loc4_:int = this.codeField.height - this.validationIcon.height >> 1;
         this.validationIcon.x = this.codeField.x + this.codeField.width - _loc4_ - this.validationIcon.height;
         this.validationIcon.y = this.codeField.y + _loc4_ + 2;
      }

      public function postRender():void
      {
         // super.postRender();
         this.codeField.addEventListener(TextEvent.TEXT_INPUT, this.textInputHandler);
         this.codeField.addEventListener(Event.CHANGE, this.textEditHandler);
         this.codeField.addEventListener(KeyboardEvent.KEY_DOWN, this.sendOnEnterHandler);
         this.sendButton.addEventListener(MouseEvent.CLICK, this.sendClickHandler);
      }

      public function destroy():void
      {
         this.codeField.removeEventListener(TextEvent.TEXT_INPUT, this.textInputHandler);
         this.codeField.removeEventListener(Event.CHANGE, this.textEditHandler);
         this.codeField.removeEventListener(KeyboardEvent.KEY_DOWN, this.sendOnEnterHandler);
         this.sendButton.removeEventListener(MouseEvent.CLICK, this.sendClickHandler);
      }

      private function getPromoCode():String
      {
         return this.code;
      }

      public function activateFailed():void
      {
         this.codeField.validValue = false;
         this.codeField.enable = true;
         this.validationIcon.markAsInvalid();
         this.invalidCodeLabel.visible = true;
      }

      public function codeActivatedSuccessful():void
      {
         this.codeField.enable = true;
         this.validationIcon.markAsValid();
      }

      public function isValidPromoCode(param1:String):Boolean
      {
         return param1.search(PROMO_CODE_PATTERN) == 0;
      }
   }
}
