package alternativa.tanks.models.battlefield.effects.graffiti
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import controls.Label;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;

    public class GraffitiMenu extends Sprite
    {

        private static const windowBitmap:Class = GraffitiMenu_windowBitmap;
        private static const rightLockBitmap:Class = GraffitiMenu_rightLockBitmap;
        private static const rightUnlockBitmap:Class = GraffitiMenu_rightUnlockBitmap;
        private static const leftLockBitmap:Class = GraffitiMenu_leftLockBitmap;
        private static const leftUnlockBitmap:Class = GraffitiMenu_leftUnlockBitmap;

        private var window:Sprite;
        private var leftLockButton:Sprite;
        private var rightUnlockButton:Sprite;
        private var leftUnlockButton:Sprite;
        private var rightLockButton:Sprite;
        private var previewBitmap:Bitmap;
        private var labelTimeLock:Label;
        private var labelName:Label;
        private var labelCount:Label;
        private var format:TextFormat = new TextFormat("BlackTuesday", 36);
        private var locked:Boolean = false;

        public function GraffitiMenu()
        {
            this.createWindow();
        }
        private function createWindow():void
        {
            this.window = new Sprite();
            this.window.addChild(new Bitmap(new windowBitmap().bitmapData));
            this.window.width = (this.window.width / 5);
            this.window.height = (this.window.height / 5);
            this.window.name = "window";
            addChild(this.window);
            this.leftLockButton = new Sprite();
            this.leftLockButton.addChild(new Bitmap(new leftLockBitmap().bitmapData));
            this.leftLockButton.width = (this.leftLockButton.width / 5);
            this.leftLockButton.height = (this.leftLockButton.height / 5);
            this.leftLockButton.x = (this.window.x + 10);
            this.leftLockButton.y = ((this.window.height - this.leftLockButton.height) - 10);
            this.leftLockButton.name = "leftLock";
            this.leftLockButton.visible = false;
            addChild(this.leftLockButton);
            this.rightUnlockButton = new Sprite();
            this.rightUnlockButton.addChild(new Bitmap(new rightUnlockBitmap().bitmapData));
            this.rightUnlockButton.width = (this.rightUnlockButton.width / 5);
            this.rightUnlockButton.height = (this.rightUnlockButton.height / 5);
            this.rightUnlockButton.x = ((this.window.width - this.rightUnlockButton.width) - 10);
            this.rightUnlockButton.y = ((this.window.height - this.rightUnlockButton.height) - 10);
            this.rightUnlockButton.name = "rightUnlock";
            this.rightUnlockButton.visible = false;
            addChild(this.rightUnlockButton);
            this.leftUnlockButton = new Sprite();
            this.leftUnlockButton.addChild(new Bitmap(new leftUnlockBitmap().bitmapData));
            this.leftUnlockButton.width = (this.leftUnlockButton.width / 5);
            this.leftUnlockButton.height = (this.leftUnlockButton.height / 5);
            this.leftUnlockButton.x = (this.window.x + 10);
            this.leftUnlockButton.y = ((this.window.height - this.leftUnlockButton.height) - 10);
            this.leftUnlockButton.name = "leftUnlock";
            this.leftUnlockButton.visible = false;
            addChild(this.leftUnlockButton);
            this.rightLockButton = new Sprite();
            this.rightLockButton.addChild(new Bitmap(new rightLockBitmap().bitmapData));
            this.rightLockButton.width = (this.rightLockButton.width / 5);
            this.rightLockButton.height = (this.rightLockButton.height / 5);
            this.rightLockButton.x = ((this.window.width - this.rightLockButton.width) - 10);
            this.rightLockButton.y = ((this.window.height - this.rightLockButton.height) - 10);
            this.rightLockButton.name = "rightLock";
            this.rightLockButton.visible = false;
            addChild(this.rightLockButton);
            this.format.color = 13293529;
            this.labelName = new Label();
            this.labelName.defaultTextFormat = this.format;
            addChild(this.labelName);
            this.labelCount = new Label();
            this.labelCount.defaultTextFormat = this.format;
            addChild(this.labelCount);
            this.labelTimeLock = new Label();
            this.labelTimeLock.defaultTextFormat = this.format;
            this.labelTimeLock.visible = false;
            addChild(this.labelTimeLock);
        }
        public function showPreview(preview:String, name:String, count:String):void
        {
            if (this.previewBitmap != null)
            {
                removeChild(this.previewBitmap);
                this.previewBitmap = null;
            }
            if (this.locked)
            {
                this.labelName.visible = false;
                this.labelCount.visible = false;
                this.labelTimeLock.visible = true;
                this.labelTimeLock.x = ((this.window.width / 2) - (this.labelTimeLock.width / 2));
                this.labelTimeLock.y = ((this.window.height / 2) - (this.labelTimeLock.height / 2));
                return;
            }
            if (this.labelTimeLock.visible)
            {
                this.labelTimeLock.visible = false;
            }
            this.previewBitmap = new Bitmap(TexturesManager.getBD(preview));
            this.previewBitmap.width = 100;
            this.previewBitmap.height = 100;
            this.previewBitmap.x = ((this.window.width / 2) - (this.previewBitmap.width / 2));
            this.previewBitmap.y = ((this.window.height / 2) - (this.previewBitmap.height / 2));
            addChild(this.previewBitmap);
            this.labelName.text = name;
            this.labelName.visible = true;
            this.labelName.x = ((this.window.width / 2) - (this.labelName.width / 2));
            this.labelName.y = ((this.window.height - this.labelName.height) - 10);
            this.labelCount.text = count;
            this.labelCount.visible = true;
            this.labelCount.x = ((this.window.width / 2) - (this.labelCount.width / 2));
            this.labelCount.y = 10;
        }
        public function openMenu(graffiti:Object):void
        {
            this.showPreview(graffiti.id, graffiti.name, graffiti.count);
            visible = true;
        }
        public function closeMenu():void
        {
            visible = false;
        }
        public function updateLockTime(seconds:int):void
        {
            this.labelTimeLock.text = String(seconds);
            this.labelTimeLock.x = ((this.window.width / 2) - (this.labelTimeLock.width / 2));
            this.labelTimeLock.y = ((this.window.height / 2) - (this.labelTimeLock.height / 2));
        }
        public function lockGraffiti():void
        {
            this.locked = true;
        }
        public function unLockGraffiti():void
        {
            this.locked = false;
        }
        public function addEventNextClick(func:Function):void
        {
            this.rightUnlockButton.addEventListener(MouseEvent.CLICK, func);
        }
        public function addEventPrevClick(func:Function):void
        {
            this.leftUnlockButton.addEventListener(MouseEvent.CLICK, func);
        }
        public function lockNextButton():void
        {
            this.rightUnlockButton.visible = false;
            this.rightLockButton.visible = true;
        }
        public function unlockNextButton():void
        {
            this.rightUnlockButton.visible = true;
            this.rightLockButton.visible = false;
        }
        public function lockPrevButton():void
        {
            this.leftUnlockButton.visible = false;
            this.leftLockButton.visible = true;
        }
        public function unlockPrevButton():void
        {
            this.leftUnlockButton.visible = true;
            this.leftLockButton.visible = false;
        }

    }
}
