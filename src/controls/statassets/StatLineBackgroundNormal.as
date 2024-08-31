package controls.statassets
{
    import flash.display.Sprite;
    import flash.display.Bitmap;

    public class StatLineBackgroundNormal extends Sprite
    {

        public static var bg:Bitmap = new Bitmap();

        public function StatLineBackgroundNormal()
        {
            addChild(new Bitmap(bg.bitmapData));
        }
    }
}
