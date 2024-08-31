package alternativa.tanks.camera
{
   import alternativa.math.Vector3;
   import alternativa.tanks.Game;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.init.Main;
   import alternativa.tanks.models.battlefield.IBattleField;

   public class CameraBookmark
   {

      public var position:Vector3;

      public var eulerAnlges:Vector3;

      public function CameraBookmark()
      {
         position = new Vector3();
         eulerAnlges = new Vector3();
         super();
      }

      public function saveCurrentPossitionCamera():void
      {
         var _local_1:GameCamera = BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport.camera;
         this.position.x = _local_1.x;
         this.position.y = _local_1.y;
         this.position.z = _local_1.z;
         this.eulerAnlges.x = _local_1.rotationX;
         this.eulerAnlges.y = _local_1.rotationY;
         this.eulerAnlges.z = _local_1.rotationZ;
      }
   }
}
