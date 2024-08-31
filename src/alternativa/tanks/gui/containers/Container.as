package alternativa.tanks.gui.containers
{
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.text.TextField;
    import flash.events.TimerEvent;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.filters.GlowFilter;
    import alternativa.tanks.gui.icons.GiftRollerListBg;
    import logic.resource.images.ImageResource;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import controls.Label;
    import flash.display.DisplayObject;
    import flash.filters.BitmapFilterQuality;

    public class Container
    {
        public var itemContainer:Sprite;
        public var maskSprite:Sprite;

        private var selectedItem:String;
        private var scrollTimer:Timer;
        private var scrollDuration:Number = 6500;
        private var itemsPerSecond:Number = 35;
        private var itemWidth:Number = 195;
        private var itemHeight:Number = 117;
        private var totalItems:int = Math.ceil(this.scrollDuration / 1000) * this.itemsPerSecond; // 228
        private var winningIndex:int = 15;
        private const winningOffset:Number = -2639.35; // TODO: get rid of hardcoding
        private var randomOffset:int = 0;
        private var skipAnim:Boolean = false;
        public function Container()
        {
            // Create the item container
            this.itemContainer = new Sprite();
            // Calculate the total number of items needed for the duration of the animation //FIXME: optimize

        }

        private function addName(name:String):Label
        {
            var label:Label = new Label();

            // Set the text
            label.text = name;
            label.size = 12;
            label.color = 0xaad18e;

            label.x = 5;
            label.y = 3;

            return label;
        }

        private function addCount(count:int):TextField
        {
            var label:Label = new Label();
            // Set the text
            label.text = "x" + count.toString();

            label.size = 15;
            label.color = 0xaad18e;

            // Position the text field at the bottom right corner with 10px padding
            label.x = this.itemWidth - label.width - 10;
            label.y = this.itemHeight - label.height - 10;

            return label;
        }

        private function addItemToContainer(index:int, item:Item):Item
        {
            var itemRarity:ItemRarity = new ItemRarity();
            var rarity:Rarity = itemRarity.getRarity(item.rarity);
            item.color = rarity.color;
            item.graphics.beginFill(0, 0);
            item.graphics.drawRect(0, 0, itemWidth, itemHeight); // Draw a square
            item.graphics.endFill();
            item.x = (index * (this.itemWidth + 5));
            item.width = this.itemWidth;
            item.height = this.itemHeight;

            var containerImg:Bitmap = new GiftRollerListBg().image;
            // make the image fill the item
            containerImg.width = itemWidth;
            containerImg.height = itemHeight;
            item.addChild(containerImg);
            var resource:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, item.previewId) as ImageResource);
            if (resource == null)
            {
                var resource:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, item.id) as ImageResource);
            }
            var img:Bitmap = new Bitmap(resource.bitmapData as BitmapData);
            // make the image fill the item
            img.width = (this.itemWidth / 100) * 80;
            img.height = (this.itemHeight / 100) * 80;

            // Create a new GlowFilter
            var glow:GlowFilter = new GlowFilter();
            glow.color = rarity.color;
            glow.alpha = 0.55;
            glow.blurX = 27.5;
            glow.blurY = 27.5;
            glow.strength = 0.5;

            var glow1:GlowFilter = new GlowFilter();
            glow1.color = rarity.color;
            glow1.alpha = 0.85;
            glow1.blurX = 10.15;
            glow1.blurY = 10.15;
            glow1.strength = 1.8;
            img.filters = [glow, glow1];

            // maintain aspect ratio
            img.scaleX = img.scaleY = Math.max(img.scaleX, img.scaleY);
            // center the image
            img.x = (itemWidth - img.width) / 2;
            img.y = (itemHeight - img.height) / 2;
            // smoothing
            img.smoothing = true;
            item.addChild(img);

            // Add the count to the item
            if (item.count > 1)
            {
                var countLabel:TextField = this.addCount(item.count);
                item.addChild(countLabel);
            }
            item.addChild(this.addName(item._name));
            // Add a label to the item
            // var label:TextField = new TextField();
            // label.text = String(index);
            // item.addChild(label);
            return item;
        }

        public function clear()
        {
            // Iterate over all the children of itemContainer
            while (this.itemContainer.numChildren > 0)
            {
                // Remove the first child
                this.itemContainer.removeChildAt(0);
            }

        }
        private var buttonReleaseCallback:Function;
        public function setButtonReleaseCallbak(f:Function):void
        {
            this.buttonReleaseCallback = f;
        }
        public function open(jsonData:Array, skip:Boolean):void
        {
            this.skipAnim = skip;
            var index:int = 0;
            // Add the items to the item container
            for each (var entry:Object in jsonData)
            {
                var genericItem:Item = new Item(entry);
                var item:Sprite = addItemToContainer(index, genericItem);
                this.itemContainer.addChild(item);
                index++;
            }
            // 
            var min:int = -154;
            var max:int = 35;
            this.randomOffset = Math.floor(Math.random() * (max - min + 1)) + min;
            // var offset:int = 0;
            // Center the item container on the stage
            this.itemContainer.x = this.randomOffset;
            this.itemContainer.y = 65;

            // Apply the mask to the itemContainer
            // this.itemContainer.mask = maskSprite;

            // Add the maskSprite to the stage

            // Create the scroll timer
            this.scrollTimer = new Timer(this.scrollDuration / totalItems); // This will make the animation take exactly scrollDuration milliseconds
            this.scrollTimer.addEventListener(TimerEvent.TIMER, onScrollTimer);
            // Start the scrolling animation
            this.startScrolling();
        }

        private function startScrolling():void
        {
            // Start the scroll timer
            this.scrollTimer.start();
        }
        private function easeInOutQuad(t:Number):Number
        {
            t /= 0.5;
            if (t < 1)
                return 0.5 * t * t;
            t--;
            return -0.5 * (t * (t - 2) - 1);
        }
        private function onScrollTimer(event:TimerEvent):void
        {
            // Calculate the total number of ticks in the animation
            var totalTicks:int = this.scrollDuration / this.scrollTimer.delay;

            // Calculate the current progress of the animation (from 0 to 1)
            var progress:Number = this.scrollTimer.currentCount / totalTicks;

            // Calculate the progress for the easing function
            // var easingProgress:Number = (progress < 0.5) ? (2 * progress) : (2 - 2 * progress);
            var easingProgress:Number = (1 - progress) * (1 - progress);
            // Use the easeInOutQuad easing function
            var easedProgress:Number = easeInOutQuad(easingProgress);

            // Calculate the current speed
            var currentSpeed:Number = easedProgress * this.itemsPerSecond;

            // Move the item container
            this.itemContainer.x -= currentSpeed;

            if (this.skipAnim)
            {
                skipAnimation();
            }

            if (progress == 1)
            {
                trace(itemContainer.x);
                // Stop the scroll timer
                this.scrollTimer.stop();
                var winningItem:Item = this.itemContainer.getChildAt(winningIndex) as Item;

                // Create a new GlowFilter instance
                var glow:GlowFilter = new GlowFilter();
                glow.color = winningItem.color; // White color

                glow.alpha = 0.85;
                glow.blurX = 5;
                glow.blurY = 5;
                glow.inner = true;
                glow.strength = 2.5;
                glow.quality = BitmapFilterQuality.HIGH;

                // Apply the glow filter to the display object
                winningItem.filters = [glow];
                this.buttonReleaseCallback.call();
            }

        }
        public function skipAnimation():void
        {
            // Check if the scrollTimer is running
            if (this.scrollTimer && this.scrollTimer.running)
            {
                // Stop the scroll timer
                this.scrollTimer.stop();
                // Set the itemContainer to its final position
                this.itemContainer.x = winningOffset + randomOffset;

                // Highlight the winning item
                var winningItem:Item = this.itemContainer.getChildAt(winningIndex) as Item;

                // Create a new GlowFilter instance
                var glow:GlowFilter = new GlowFilter();
                glow.color = winningItem.color;

                glow.alpha = 0.85;
                glow.blurX = 5;
                glow.blurY = 5;
                glow.inner = true;
                glow.strength = 2.5;
                glow.quality = BitmapFilterQuality.HIGH;

                // Apply the glow filter to the display object
                winningItem.filters = [glow];

                // Call the button release callback
                this.buttonReleaseCallback.call();
            }
        }
    }

}