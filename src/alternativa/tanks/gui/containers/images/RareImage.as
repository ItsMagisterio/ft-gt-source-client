package alternativa.tanks.gui.containers.images {

    import flash.display.Bitmap;

    public class RareImage
    {
        [Embed(source="rare.png")]
        private var ultimg:Class;

        public var image:Bitmap;

        public function RareImage()
        {
            this.image = new ultimg() as Bitmap;
        }
    }
}