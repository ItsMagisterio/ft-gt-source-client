package alternativa.tanks.model.quest.challenge.gui
{
   import alternativa.osgi.service.locale.ILocaleService;
   import base.DiscreteSprite;
   import controls.Label;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import forms.ColorConstants;
   import projects.tanks.clients.fp10.libraries.TanksLocale;

   public class ChallengesProgressView extends DiscreteSprite
   {

      [Inject]
      public static var localeService:ILocaleService;

      private static const progressBarBgClass:Class = ChallengesProgressView_progressBarBgClass;

      private static const progressBarBgBitmapData:BitmapData = new progressBarBgClass().bitmapData;

      private static const progressBarFillBgClass:Class = ChallengesProgressView_progressBarFillBgClass;

      private static const progressBarFillBgBitmapData:BitmapData = new progressBarFillBgClass().bitmapData;

      private static const starClass:Class = ChallengesProgressView_starClass;

      private static const starBitmapData:BitmapData = new starClass().bitmapData;

      private var point:Point;

      private var fillBitmap:Bitmap;

      private var label;

      public function ChallengesProgressView()
      {
         this.point = new Point();
         this.fillBitmap = new Bitmap();
         this.label = new Label();
         super();
         addChild(new Bitmap(progressBarBgBitmapData));
         addChild(this.fillBitmap);
         var _loc1_:Bitmap = new Bitmap(starBitmapData);
         _loc1_.x = 5;
         _loc1_.y = 6;
         addChild(_loc1_);
         this.label.bold = true;
         this.label.color = ColorConstants.GREEN_LABEL;
         this.label.x = _loc1_.x + _loc1_.width + 5;
         this.label.y = 3;
         addChild(this.label);
      }

      public function setProgress(param1:int, param2:int, param3:int):void
      {
         this.label.text = localeService.getText(TanksLocale.TEXT_CHALLENGE_STARS) + " " + param2 + "/" + param3;
         if (param1 == 0)
         {
            this.fillBitmap.bitmapData = null;
            return;
         }
         if (param1 == 100)
         {
            this.fillBitmap.bitmapData = progressBarFillBgBitmapData;
            return;
         }
         var _loc4_:Number = progressBarBgBitmapData.width * param1 / 100;
         var _loc5_:BitmapData = new BitmapData(_loc4_, progressBarBgBitmapData.height);
         _loc5_.copyPixels(progressBarFillBgBitmapData, _loc5_.rect, this.point);
         this.fillBitmap.bitmapData = _loc5_;
      }
   }
}
