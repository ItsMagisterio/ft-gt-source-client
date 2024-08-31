package controls.scroller.gray
{
    import controls.scroller.ScrollThumbSkin;

    public class ScrollThumbSkinGray extends ScrollThumbSkin
    {

        override public function initSkin():void
        {
            toppng = new ScrollSkinGray.thumbTop().bitmapData;
            midpng = new ScrollSkinGray.thumbMiddle().bitmapData;
        }

    }
}
