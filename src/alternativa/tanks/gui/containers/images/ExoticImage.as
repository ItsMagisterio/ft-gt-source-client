package alternativa.tanks.gui.containers.images {

    import flash.display.Bitmap;

    public class ExoticImage
    {
        [Embed(source="exotic.png")]
        private var ultimg:Class;

        public var image:Bitmap;

        public function ExoticImage()
        {
            this.image = new ultimg() as Bitmap;
        }
    }
}