package alternativa.tanks.gui.containers.images {

    import flash.display.Bitmap;

    public class UltimateImage
    {
        [Embed(source="ultimate.png")]
        private var ultimg:Class;

        public var image:Bitmap;

        public function UltimateImage()
        {
            this.image = new ultimg() as Bitmap;
        }
    }
}