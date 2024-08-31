// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.test.UpdateRankLabel

package logic.test
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import controls.Label;
    import controls.rangicons.RangsIcon;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import alternativa.init.Main;

    public class UpdateRankLabel extends Sprite
    {

        private static const bitmapCrystal:Class = UpdateRankLabel_bitmapCrystal;
        private static const crystalBd:BitmapData = new bitmapCrystal().bitmapData;

        private var time:int = 0;
        private var _alpha:Number = 1;
        private var icon:Bitmap;
        private var crystalIcon:Bitmap;
        private var welcome:Label;
        private var rankNotification:Label;
        private var priseNotification:Label;

        public function UpdateRankLabel(rankName:String, rang:int)
        {
            this.icon = new Bitmap(RangsIcon.getBD(rang));
            this.crystalIcon = new Bitmap(crystalBd);
            this.welcome = new Label();
            this.rankNotification = new Label();
            this.priseNotification = new Label();
            super();
            this.welcome.size = 20;
            this.rankNotification.size = 20;
            this.priseNotification.size = 20;
            this.welcome.textColor = 16777011;
            this.rankNotification.textColor = 16777011;
            this.priseNotification.textColor = 16777011;
            var glow:GlowFilter = new GlowFilter(0);
            this.filters = [glow];
            this.welcome.text = "Congratulations!";
            this.rankNotification.text = (("You have reached the rank of «" + rankName) + "»");
            this.priseNotification.text = ("Your gift " + UpdateRankPrize.getCount(rang));
            addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onDeleteFromFrame);
        }
        private function onAdded(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            addEventListener(Event.ENTER_FRAME, this.update, false, 0, false);
            Main.stage.addEventListener(Event.RESIZE, this.resize);
            addChild(this.icon);
            addChild(this.crystalIcon);
            addChild(this.welcome);
            addChild(this.rankNotification);
            addChild(this.priseNotification);
            this.resize(null);
        }
        public function resize(e:Event):void
        {
            this.welcome.x = ((Main.stage.stageWidth - this.welcome.width) >>> 1);
            this.welcome.y = (((Main.stage.stageHeight / 2) - (this.height / 2)) - this.rankNotification.height);
            this.rankNotification.x = ((Main.stage.stageWidth - this.rankNotification.width) >>> 1);
            this.rankNotification.y = (this.welcome.y + this.rankNotification.height);
            this.priseNotification.x = ((Main.stage.stageWidth / 2) - (this.priseNotification.width / 2));
            this.priseNotification.y = ((this.rankNotification.y + this.priseNotification.height) + 20);
            this.icon.x = ((Main.stage.stageWidth / 2) - (this.icon.width / 2));
            this.icon.y = ((this.welcome.y - this.icon.height) - 10);
            this.crystalIcon.x = ((this.priseNotification.x + this.priseNotification.width) + 5);
            this.crystalIcon.y = this.priseNotification.y;
        }
        private function update(e:Event):void
        {
            this.time = (this.time + 20);
            if (this.time >= 2500)
            {
                this._alpha = (this._alpha - 0.05);
                this.alpha = this._alpha;
                if (this._alpha <= 0.01)
                {
                    removeEventListener(Event.ENTER_FRAME, this.update);
                    removeEventListener(Event.RESIZE, this.resize);
                    this.filters = [];
                    this.onDeleteFromFrame(null);
                }
            }
        }
        private function onDeleteFromFrame(e:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.onDeleteFromFrame);
            removeChild(this.icon);
            removeChild(this.crystalIcon);
            removeChild(this.welcome);
            removeChild(this.rankNotification);
            removeChild(this.priseNotification);
            Main.contentUILayer.removeChild(this);
        }

    }
} // package scpacker.test