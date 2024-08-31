package alternativa.tanks.camera
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.display.CameraFovCalculator;

   public class GameCamera extends Camera3D
   {

      private static const m:Matrix3 = new Matrix3();

      private static const eulerAngles:Vector3 = new Vector3();

      public var position:Vector3;

      public var xAxis:Vector3;

      public var yAxis:Vector3;

      public var zAxis:Vector3;

      public function GameCamera()
      {
         position = new Vector3();
         xAxis = new Vector3();
         yAxis = new Vector3();
         zAxis = new Vector3();
         super();
         nearClipping = 40;
         farClipping = 200000;
         z = 10000;
         rotationX = -0.01;
         diagramVerticalMargin = 35;
      }

      public function calculateAdditionalData():void
      {
         var _local_5:Number = NaN;
         var _local_1:Number = Math.cos(rotationX);
         var _local_2:Number = Math.sin(rotationX);
         var _local_3:Number = Math.cos(rotationY);
         var _local_4:Number = Math.sin(rotationY);
         _local_5 = Math.cos(rotationZ);
         var _local_6:Number = Math.sin(rotationZ);
         var _local_7:Number = _local_5 * _local_4;
         var _local_8:Number = _local_6 * _local_4;
         this.xAxis.x = _local_5 * _local_3;
         this.yAxis.x = _local_7 * _local_2 - _local_6 * _local_1;
         this.zAxis.x = _local_7 * _local_1 + _local_6 * _local_2;
         this.xAxis.y = _local_6 * _local_3;
         this.yAxis.y = _local_8 * _local_2 + _local_5 * _local_1;
         this.zAxis.y = _local_8 * _local_1 - _local_5 * _local_2;
         this.xAxis.z = -_local_4;
         this.yAxis.z = _local_3 * _local_2;
         this.zAxis.z = _local_3 * _local_1;
         this.position.x = x;
         this.position.y = y;
         this.position.z = z;
      }

      public function getGlobalVector(_arg_1:Vector3, _arg_2:Vector3):void
      {
         m.setRotationMatrix(rotationX, rotationY, rotationZ);
         m.transformVector(_arg_1, _arg_2);
      }

      public function getLocalVector(_arg_1:Vector3, _arg_2:Vector3):void
      {
         m.setRotationMatrix(rotationX, rotationY, rotationZ);
         m.transformVectorInverse(_arg_1, _arg_2);
      }

      public function setPosition(_arg_1:Vector3):void
      {
         x = _arg_1.x;
         y = _arg_1.y;
         z = _arg_1.z;
      }

      public function setRotation(_arg_1:Vector3):void
      {
         rotationX = _arg_1.x;
         rotationY = _arg_1.y;
         rotationZ = _arg_1.z;
      }

      public function setQRotation(_arg_1:Quaternion):void
      {
         _arg_1.getEulerAngles(eulerAngles);
         this.setRotation(eulerAngles);
      }

      public function readPosition(_arg_1:Vector3):void
      {
         _arg_1.x = x;
         _arg_1.y = y;
         _arg_1.z = z;
      }

      public function readRotation(_arg_1:Vector3):void
      {
         _arg_1.x = rotationX;
         _arg_1.y = rotationY;
         _arg_1.z = rotationZ;
      }

      public function readQRotation(_arg_1:Quaternion):void
      {
         _arg_1.setFromEulerAnglesXYZ(rotationX, rotationY, rotationZ);
      }

      public function updateFov():void
      {
         fov = CameraFovCalculator.getCameraFov(view.width, view.height);
      }

      public function get pos():Vector3
      {
         return position;
      }

      public function rotateBy(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
      {
         rotationX += _arg_1;
         rotationY += _arg_2;
         rotationZ += _arg_3;
      }
   }
}
