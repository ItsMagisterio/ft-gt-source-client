package alternativa.tanks.gui.icons {

    import flash.display.Bitmap;

    public class FirstAid
    {
        [Embed(source="fa.png")]
        private var fa:Class;
        public var image:Bitmap;

        public function FirstAid()
        {
            this.image = new fa() as Bitmap;
        }
    }
}