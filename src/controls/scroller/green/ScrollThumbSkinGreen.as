package controls.scroller.green
{
    import controls.scroller.ScrollThumbSkin;

    public class ScrollThumbSkinGreen extends ScrollThumbSkin
    {

        override public function initSkin():void
        {
            toppng = new ScrollSkinGreen.thumbTop().bitmapData;
            midpng = new ScrollSkinGreen.thumbMiddle().bitmapData;
        }

    }
}
