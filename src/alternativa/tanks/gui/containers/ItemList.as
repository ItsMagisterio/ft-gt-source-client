package alternativa.tanks.gui.containers
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import alternativa.tanks.gui.containers.images.UltimateImage;
    import logic.resource.images.ImageResource;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import flash.display.BitmapData;
    import fl.containers.ScrollPane;
    import alternativa.tanks.gui.containers.images.CommonImage;
    import alternativa.tanks.gui.containers.images.RareImage;
    import alternativa.tanks.gui.containers.images.EpicImage;
    import alternativa.tanks.gui.containers.images.LegendaryImage;
    import alternativa.tanks.gui.containers.images.ExoticImage;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import controls.Label;
    // create enum

    public class ItemList extends Sprite
    {

        private var _list:Vector.<Item>;
        public function ItemList()
        {
            this._list = new Vector.<Item>();
        }

        private var itemWidth:Number = 161;
        private var itemHeight:Number = 114;
        private var itemGap:Number = 2;

        public function generateItemList(main:Sprite, jsonArr:Array, pane:ScrollPane):void
        {
            var xPos:Number = 0;
            var yPos:Number = 0;
            var itemCount:int = 1;

            var containerItemWidth:Number = 0;

            for each (var item:Object in jsonArr)
            {
                var outItem:Item = new Item(item);

                outItem.graphics.beginFill(0, 0); // Change the color as needed
                outItem.graphics.drawRect(0, 0, this.itemWidth, this.itemHeight); // Set the width and height as needed
                outItem.graphics.endFill();
                outItem.width = this.itemWidth;
                outItem.height = this.itemHeight;
                // add img
                var containerImg:Bitmap = bitmapByRarity(item.rarity);
                // make the image fill the item
                containerImg.width = itemWidth;
                containerImg.height = itemHeight;

                outItem.addChild(containerImg);

                var resource:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, outItem.previewId) as ImageResource);
                if (resource == null)
                {
                    var resource:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, item.id) as ImageResource);
                }
                var img:Bitmap = new Bitmap(resource.bitmapData as BitmapData);
                // make the image fill the item
                img.width = (this.itemWidth / 100) * 70;
                img.height = (this.itemHeight / 100) * 70;
                // maintain aspect ratio
                img.scaleX = img.scaleY = Math.max(img.scaleX, img.scaleY);
                // center the image
                img.x = (itemWidth - img.width) / 2;
                img.y = (itemHeight - img.height) / 2;
                // smoothing
                img.smoothing = true;
                outItem.addChild(img);

                if (itemCount % 2 == 0)
                {
                    yPos += outItem.height + itemGap;
                }
                outItem.x = xPos;
                outItem.y = yPos;

                // COUNT
                if (outItem.count > 1)
                {
                    outItem.addChild(addCount(outItem.count));
                }
                outItem.addChild(addName(outItem._name));
                // Add the text field to the outItem

                main.addChild(outItem);

                // cycle is done, move to the next row
                if (itemCount % 2 == 0)
                {
                    yPos = 0;
                    xPos += outItem.width + itemGap; // Update the y position for the next sprite
                }

                this._list.push(outItem);
                itemCount++;
            }
            pane.update();

        }

        private function addCount(count:int):TextField
        {
            var label:Label = new Label();

            // Set the text
            label.text = "x" + count.toString();

            label.size = 16;
            label.color = 0xaad18e;

            // Position the text field at the bottom right corner with 10px padding
            label.x = this.itemWidth - label.width - 12;
            label.y = this.itemHeight - label.height - 10;

            return label;
        }

        private function addName(name:String):Label
        {
            var label:Label = new Label();

            // Set the text
            label.text = name;

            label.size = 11;
            label.color = 0xaad18e;

            label.x = 8;
            label.y = 8;

            return label;
        }

        private function bitmapByRarity(rarity:String):Bitmap
        {
            var rarityImg:Bitmap;
            switch (rarity)
            {
                case "common":
                    rarityImg = new CommonImage().image;
                    break;
                case "rare":
                    rarityImg = new RareImage().image;
                    break;
                case "epic":
                    rarityImg = new EpicImage().image;
                    break;
                case "legendary":
                    rarityImg = new LegendaryImage().image;
                    break;
                case "exotic":
                    rarityImg = new ExoticImage().image;
                    break;
                case "ultimate":
                    rarityImg = new UltimateImage().image;
                    break;
                default:
                    rarityImg = new CommonImage().image;
                    break;
            }
            return rarityImg;
        }

        public function get list():Vector.<Item>
        {
            return this._list;
        }
    }
}