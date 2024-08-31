package controls.scroller.red
{
    import controls.scroller.ScrollThumbSkin;

    public class ScrollThumbSkinRed extends ScrollThumbSkin
    {

        override public function initSkin():void
        {
            toppng = new ScrollSkinRed.thumbTop().bitmapData;
            midpng = new ScrollSkinRed.thumbMiddle().bitmapData;
        }

    }
}
