package platform.client.fp10.core.resource.types
{
   import platform.client.fp10.core.resource.ResourceInfo;

   public class ScalableImageResource extends ImageResource
   {

      private static const IMAGE_FILE:String = "image_x15.tnk";

      public function ScalableImageResource(param1:ResourceInfo)
      {
         super(param1);
      }

      override protected function getImageFileName():String
      {
         return IMAGE_FILE;
      }
   }
}
