package alternativa.tanks.engine3d.debug
{
    import alternativa.tanks.engine3d.IndexedTextureConstructor;
    import flash.display.BitmapData;
    import alternativa.utils.ITextureConstructorListener;
    import flash.utils.setTimeout;
    import alternativa.utils.TextureByteData;

    public class DummyIndexedTextureConstructor extends IndexedTextureConstructor
    {

        private static var bmp:BitmapData;

        private var listener:ITextureConstructorListener;

        public function DummyIndexedTextureConstructor()
        {
            var size:int;
            var i:int;
            var ii:int;
            var j:int;
            var jj:int;
            super();
            if (bmp == null)
            {
                size = 100;
                bmp = new BitmapData(size, size, false, 0x7F7F7F);
                i = 0;
                while (i < size)
                {
                    ii = int(((i * 5) / size));
                    j = 0;
                    while (j < size)
                    {
                        jj = int(((j * 5) / size));
                        if (ii + jj == 1)
                        {
                            bmp.setPixel(i, j, 0x333333);
                        }
                        j++;
                    }
                    i++;
                }
            }
        }
        override public function get texture():BitmapData
        {
            return (bmp);
        }
        override public function createTexture(textureData:TextureByteData, listener:ITextureConstructorListener):void
        {
            this.listener = listener;
            setTimeout(this.notify, 0);
        }
        private function notify():void
        {
            var lsnr:ITextureConstructorListener = this.listener;
            this.listener = null;
            lsnr.onTextureReady(this);
        }

    }
}
