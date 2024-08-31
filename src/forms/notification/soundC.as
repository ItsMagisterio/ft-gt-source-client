package forms.notification
{
   import mx.core.SoundAsset;
   
   [ExcludeClass]
   [Embed(source="notify.mp3", mimeType="application/octet-stream")]
   public class soundC extends SoundAsset
   {
      public function soundC()
      {
         super();
      }
   }
}
