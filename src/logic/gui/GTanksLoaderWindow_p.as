// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.gui.GTanksLoaderWindow_p

package logic.gui
{
    import mx.core.MovieClipLoaderAsset;
    import flash.utils.ByteArray;

    public class GTanksLoaderWindow_p extends MovieClipLoaderAsset
    {

        private static var bytes:ByteArray = null;

        public var dataClass:Class = GTanksLoaderWindow_p_dataClass;

        public function GTanksLoaderWindow_p()
        {
            initialWidth = (14960 / 20);
            initialHeight = (1440 / 20);
        }
        override public function get movieClipData():ByteArray
        {
            if (bytes == null)
            {
                bytes = ByteArray(new this.dataClass());
            }
            return (bytes);
        }

    }
} // package scpacker.gui