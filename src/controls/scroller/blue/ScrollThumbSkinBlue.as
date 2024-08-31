package controls.scroller.blue
{
    import controls.scroller.ScrollThumbSkin;

    public class ScrollThumbSkinBlue extends ScrollThumbSkin
    {

        override public function initSkin():void
        {
            toppng = new ScrollSkinBlue.thumbTop().bitmapData;
            midpng = new ScrollSkinBlue.thumbMiddle().bitmapData;
        }

    }
}
