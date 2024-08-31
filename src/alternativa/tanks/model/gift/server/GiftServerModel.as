package alternativa.tanks.model.gift.server
{
    import alternativa.tanks.model.panel.IPanel;
    import flash.display.DisplayObjectContainer;
    import alternativa.tanks.model.gift.GiftView;
    import alternativa.init.Main;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class GiftServerModel
    {

        private var panelModel:IPanel;
        private var dialogsLayer:DisplayObjectContainer;
        private var view:GiftView;

        public function GiftServerModel()
        {
            this.dialogsLayer = Main.dialogsLayer;
        }
        [ServerMethods]
        public function openGiftWindow(items:Array, count:int):*
        {
            this.panelModel = (Main.osgi.getService(IPanel) as IPanel);
            this.panelModel.blur();
            this.view = new GiftView(items, count);
            this.view.closeButton.addEventListener(MouseEvent.CLICK, this.closeWindow);
            Main.stage.addEventListener(Event.RESIZE, this.alignWindow);
            this.dialogsLayer.addChild(this.view);
            this.alignWindow(null);
        }
        [ServerMethods]
        public function doRoll(winnerItem:String, countItems:Array, offsetCrystalls:int, itemName:String, rarity:int):*
        {
            //this.view.rolls([winnerItem]);
            this.view.roll(winnerItem, countItems, offsetCrystalls, itemName, rarity);
        }
        [ServerMethods]
        public function doRolls(items:Array):*
        {
            this.view.rolls(items);
        }
        public function closeWindow(e:MouseEvent = null):void
        {
            if(this.view != null){
                (Main.osgi.getService(IPanel) as IPanel).unblur();
                this.dialogsLayer.removeChild(this.view);
                Main.stage.removeEventListener(Event.RESIZE, this.alignWindow);
                this.view = null;
            }
        }
        private function alignWindow(e:Event):void
        {
            this.view.x = Math.round(((Main.stage.stageWidth - this.view.width) * 0.5));
            this.view.y = Math.round(((Main.stage.stageHeight - this.view.height) * 0.5));
        }

    }
}
