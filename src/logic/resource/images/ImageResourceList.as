// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.images.ImageResourceList

package logic.resource.images
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import __AS3__.vec.*;

    public class ImageResourceList
    {

        public var images:Dictionary;
        private var ids:Vector.<String>;

        public function ImageResourceList()
        {
            this.images = new Dictionary();
            this.ids = new Vector.<String>();
        }
        public function add(img:ImageResource):void
        {
            if (this.images[img.id] == null)
            {
                if (img.bitmapData != null)
                {
                    this.images[img.id] = img;
                    this.ids.push(img.id);
                    // /trace(((("Загрузили " + img.id) + ": ") + img.bitmapData));
                }
                else
                {
                    throw (new Error(("Bitmap null! " + img.id)));
                }
            }
            else
            {
                img.bitmapData = null;
            }
        }
        public function getImage(key:String):ImageResource
        {
            return (this.images[key]);
        }
        public function isLoaded(key:String):Boolean
        {
            return (!((this.images[key] == null) || ((this.images[key].bitmapData as BitmapData) == null)));
        }
        public function clear():void
        {
            var s:String;
            for each (s in this.ids)
            {
                this.images[s].bitmapData = null;
                this.images[s] = null;
            }
            this.images = new Dictionary();
            this.ids = new Vector.<String>();
        }
        public function getIds():Vector.<String>
        {
            return (this.ids);
        }

    }
} // package scpacker.resource.images