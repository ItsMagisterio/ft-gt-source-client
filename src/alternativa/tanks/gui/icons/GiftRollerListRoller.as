package alternativa.tanks.gui.icons {

    import flash.display.Bitmap;

    public class GiftRollerListRoller
    {
        [Embed(source="GiftRollerListRoller.png")]
        private var grlroller:Class;
        public var image:Bitmap;

        public function GiftRollerListRoller()
        {
            this.image = new grlroller() as Bitmap;
        }
    }
}