package alternativa.tanks.gui.icons {

    import flash.display.Bitmap;

    public class GiftRollerListBg
    {
        [Embed(source="GiftRollerList__bg.png")]
        private var grlbg:Class;
        public var image:Bitmap;

        public function GiftRollerListBg()
        {
            this.image = new grlbg() as Bitmap;
        }
    }
}