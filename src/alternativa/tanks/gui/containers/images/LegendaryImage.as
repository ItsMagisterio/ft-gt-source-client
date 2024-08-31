package alternativa.tanks.gui.containers.images {

    import flash.display.Bitmap;

    public class LegendaryImage
    {
        [Embed(source="legendary.png")]
        private var ultimg:Class;

        public var image:Bitmap;

        public function LegendaryImage()
        {
            this.image = new ultimg() as Bitmap;
        }
    }
}