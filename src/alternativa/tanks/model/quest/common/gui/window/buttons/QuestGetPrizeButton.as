package alternativa.tanks.model.quest.common.gui.window.buttons
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.quest.common.gui.window.buttons.skin.GreenBigButtonSkin;
   import controls.base.ThreeLineBigButton;
   import controls.labels.MouseDisabledLabel;

   public class QuestGetPrizeButton extends ThreeLineBigButton
   {

      [Inject]
      public static var localeService:ILocaleService;

      private var priceLabel:MouseDisabledLabel;

      public function QuestGetPrizeButton()
      {
         super();
         this.priceLabel = new MouseDisabledLabel();
         this.priceLabel.size = 11;
         setSkin(GreenBigButtonSkin.GREEN_SKIN);
         super.setText("Забрать");
         super.showInOneRow(captionLabel);
      }
   }
}
