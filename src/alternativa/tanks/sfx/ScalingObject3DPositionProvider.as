﻿package alternativa.tanks.sfx
{
    import alternativa.tanks.utils.objectpool.PooledObject;
    import alternativa.math.Vector3;
    import alternativa.tanks.utils.objectpool.ObjectPool;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.camera.GameCamera;

    public class ScalingObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
    {

        private var initialPosition:Vector3 = new Vector3();
        private var velocity:Vector3 = new Vector3();
        private var scaleVelocity:Number;

        public function ScalingObject3DPositionProvider(param1:ObjectPool)
        {
            super(param1);
        }
        public function initPosition(param1:Object3D):void
        {
            param1.x = this.initialPosition.x;
            param1.y = this.initialPosition.y;
            param1.z = this.initialPosition.z;
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.scaleZ = 1;
        }
        public function init(param1:Vector3, param2:Vector3, param3:Number):void
        {
            this.initialPosition.vCopy(param1);
            this.velocity.vCopy(param2);
            this.scaleVelocity = param3;
        }
        public function updateObjectPosition(param1:Object3D, param2:GameCamera, param3:int):void
        {
            var _loc4_:Number = (0.001 * param3);
            param1.x = (param1.x + (this.velocity.x * _loc4_));
            param1.y = (param1.y + (this.velocity.y * _loc4_));
            param1.z = (param1.z + (this.velocity.z * _loc4_));
            param1.scaleX = (param1.scaleX + this.scaleVelocity);
            param1.scaleY = (param1.scaleY + this.scaleVelocity);
            param1.scaleZ = (param1.scaleZ + this.scaleVelocity);
        }
        public function destroy():void
        {
        }

    }
}
