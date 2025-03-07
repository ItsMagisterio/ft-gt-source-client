﻿package alternativa.tanks.models.battlefield.logic.updaters
{
    import alternativa.math.Vector3;
    import alternativa.math.Matrix3;
    import alternativa.math.Quaternion;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.physics.BodyState;
    import alternativa.physics.Body;

    public class RemoteHullTransformUpdater implements HullTransformUpdater
    {

        private static const position:Vector3 = new Vector3();
        private static const m3:Matrix3 = new Matrix3();
        private static const SMOOTHING_COEFF:Number = (Math.PI / 10.4719);
        private static const smoothedEulerAngles:Vector3 = new Vector3();

        private const smoothedPosition:Vector3 = new Vector3();
        private const smoothedOrientation:Quaternion = new Quaternion();

        private var tank:Tank;

        public function RemoteHullTransformUpdater(param1:Tank)
        {
            this.tank = param1;
        }
        private static function smoothValue(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number):Number
        {
            param1 = (param1 + (param2 * param3));
            return (param1 + ((param4 - param1) * param5));
        }

        public function reset():void
        {
            var _loc1_:BodyState = this.tank.prevState;
            this.smoothedPosition.vCopy(_loc1_.pos);
            this.smoothedOrientation.copy(_loc1_.orientation);
        }
        public function update(param1:Number):void
        {
            var _loc5_:Vector3;
            _loc5_ = null;
            var _loc2_:Body = this.tank;
            var _loc3_:BodyState = _loc2_.prevState;
            var _loc4_:Vector3 = _loc3_.velocity;
            _loc4_.x = 0;
            _loc4_.y = 0;
            _loc4_.z = 0;
            _loc5_ = this.tank.interpolatedPosition;
            var _loc6_:Number = SMOOTHING_COEFF;
            this.smoothedPosition.x = smoothValue(this.smoothedPosition.x, _loc4_.x, param1, _loc5_.x, _loc6_);
            this.smoothedPosition.y = smoothValue(this.smoothedPosition.y, _loc4_.y, param1, _loc5_.y, _loc6_);
            this.smoothedPosition.z = smoothValue(this.smoothedPosition.z, _loc4_.z, param1, _loc5_.z, _loc6_);
            var _loc7_:Vector3 = _loc3_.rotation;
            _loc7_.x = 0;
            _loc7_.y = 0;
            _loc7_.z = 0;
            this.smoothedOrientation.addScaledVector(_loc7_, param1);
            this.smoothedOrientation.slerp(this.smoothedOrientation, this.tank.interpolatedOrientation, _loc6_);
            this.smoothedOrientation.getEulerAngles(smoothedEulerAngles);
            this.smoothedOrientation.toMatrix3(m3);
            position.vCopy(this.tank.skinCenterOffset);
            position.vTransformBy3(m3);
            position.vAdd(this.smoothedPosition);
            this.tank.skin.updateHullTransform(position, smoothedEulerAngles);
        }

    }
}
