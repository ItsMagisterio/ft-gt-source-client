package alternativa.tanks.camera
{
   public class CameraBookmarks
   {

      private var bookmarks:Vector.<CameraBookmark>;

      public function CameraBookmarks(_arg_1:int)
      {
         super();
         this.bookmarks = new Vector.<CameraBookmark>(_arg_1);
      }

      public function getBookmark(_arg_1:uint):CameraBookmark
      {
         if (_arg_1 < this.bookmarks.length)
         {
            return this.bookmarks[_arg_1];
         }
         return null;
      }

      public function saveCurrentPositionCameraToBookmark(_arg_1:uint):void
      {
         if (_arg_1 < this.bookmarks.length)
         {
            this.getOrCreateBookmark(_arg_1).saveCurrentPossitionCamera();
         }
      }

      private function getOrCreateBookmark(_arg_1:uint):CameraBookmark
      {
         if (this.bookmarks[_arg_1] == null)
         {
            this.bookmarks[_arg_1] = new CameraBookmark();
         }
         return this.bookmarks[_arg_1];
      }
   }
}
