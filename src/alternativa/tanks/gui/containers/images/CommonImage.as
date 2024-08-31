package alternativa.tanks.gui.containers.images {

    import flash.display.Bitmap;

    public class CommonImage
    {
        [Embed(source="common.png")]
        private var ultimg:Class;

        public var image:Bitmap;

        public function CommonImage()
        {
            this.image = new ultimg() as Bitmap;
        }
    }
}