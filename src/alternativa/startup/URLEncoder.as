package alternativa.startup
{
   import flash.utils.ByteArray;
   import mx.utils.Base64Encoder;

   public class URLEncoder
   {

      public function URLEncoder()
      {
         super();
      }

      public static function encode(text:String):String
      {
         var _loc2_:Base64Encoder = new Base64Encoder();
         _loc2_.insertNewLines = false;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUTFBytes(text);
         _loc2_.encodeUTFBytes(byteArray.toString());
         return _loc2_.toString();
      }
   }
}
