package platform.client.core.general.resourcelocale.format
{
   public class LocalizedFileFormat
   {

      private var _images:Vector.<platform.client.core.general.resourcelocale.format.ImagePair>;

      private var _strings:Vector.<platform.client.core.general.resourcelocale.format.StringPair>;

      public function LocalizedFileFormat(param1:Vector.<platform.client.core.general.resourcelocale.format.ImagePair> = null, param2:Vector.<platform.client.core.general.resourcelocale.format.StringPair> = null)
      {
         super();
         this._images = param1;
         this._strings = param2;
      }

      public function get images():Vector.<platform.client.core.general.resourcelocale.format.ImagePair>
      {
         return this._images;
      }

      public function set images(param1:Vector.<platform.client.core.general.resourcelocale.format.ImagePair>):void
      {
         this._images = param1;
      }

      public function get strings():Vector.<platform.client.core.general.resourcelocale.format.StringPair>
      {
         return this._strings;
      }

      public function set strings(param1:Vector.<platform.client.core.general.resourcelocale.format.StringPair>):void
      {
         this._strings = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "LocalizedFileFormat [";
         _loc1_ += "images = " + this.images + " ";
         _loc1_ += "strings = " + this.strings + " ";
         return _loc1_ + "]";
      }
   }
}
