package controls.statassets
{
    import flash.display.Sprite;
    import flash.display.Bitmap;

    public class ReferalStatLineBackgroundSelected extends Sprite
    {

        public static var bg:Bitmap = new Bitmap();

        public function ReferalStatLineBackgroundSelected()
        {
            addChild(new Bitmap(bg.bitmapData));
        }
    }
}
