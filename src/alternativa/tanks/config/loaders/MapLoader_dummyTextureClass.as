package alternativa.tanks.config.loaders
{
   import mx.core.ByteArrayAsset;

   [ExcludeClass]
   [Embed(source="dummyTextureClass.bin", mimeType="application/octet-stream")]
   public class MapLoader_dummyTextureClass extends ByteArrayAsset
   {
      public function MapLoader_dummyTextureClass()
      {
         super();
      }
   }
}
