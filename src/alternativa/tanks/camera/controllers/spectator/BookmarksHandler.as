package alternativa.tanks.camera.controllers.spectator
{
   import alternativa.tanks.camera.CameraBookmark;
   import alternativa.tanks.camera.CameraBookmarks;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;

   public class BookmarksHandler implements KeyboardHandler
   {

      private static const bookmarkKeys:Dictionary = createKeyMap();

      private const bookmarks:CameraBookmarks = new CameraBookmarks(4);

      private var listener:BookmarkListener;

      public function BookmarksHandler()
      {
         super();
      }

      private static function createKeyMap():Dictionary
      {
         var _local_1:Dictionary = new Dictionary();
         _local_1[48] = 0;
         _local_1[55] = 1;
         _local_1[56] = 2;
         _local_1[57] = 3;
         return _local_1;
      }

      public function setListener(_arg_1:BookmarkListener):void
      {
         this.listener = _arg_1;
      }

      public function handleKeyDown(_arg_1:KeyboardEvent):void
      {
         var _local_2:* = bookmarkKeys[_arg_1.keyCode];
         if (_local_2 != null)
         {
            if (_arg_1.ctrlKey)
            {
               this.saveCurrentPositionCameraToBookmark(_local_2);
            }
            else
            {
               this.goToBookmark(_local_2);
            }
         }
      }

      public function handleKeyUp(_arg_1:KeyboardEvent):void
      {
      }

      private function saveCurrentPositionCameraToBookmark(_arg_1:int):void
      {
         this.bookmarks.saveCurrentPositionCameraToBookmark(_arg_1);
      }

      private function goToBookmark(_arg_1:int):void
      {
         var _local_2:CameraBookmark = this.bookmarks.getBookmark(_arg_1);
         if (_local_2 != null && this.listener != null)
         {
            this.listener.onBookmarkSelected(_local_2);
         }
      }
   }
}
