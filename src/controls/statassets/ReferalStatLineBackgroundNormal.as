package controls.statassets
{
    import flash.display.Sprite;
    import flash.display.Bitmap;

    public class ReferalStatLineBackgroundNormal extends Sprite
    {

        public static var bg:Bitmap = new Bitmap();

        public function ReferalStatLineBackgroundNormal()
        {
            addChild(new Bitmap(bg.bitmapData));
        }
    }
}
