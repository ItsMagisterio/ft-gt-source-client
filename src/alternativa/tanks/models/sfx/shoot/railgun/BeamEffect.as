package alternativa.tanks.models.sfx.shoot.railgun
{
    import alternativa.tanks.utils.objectpool.PooledObject;
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
    import alternativa.math.Vector3;
    import alternativa.tanks.utils.objectpool.ObjectPool;
    import alternativa.engine3d.materials.Material;
    import alternativa.tanks.sfx.SFXUtils;
    import alternativa.tanks.camera.GameCamera;
    import alternativa.object.ClientObject;

    public class BeamEffect extends PooledObject implements IGraphicEffect
    {

        private var container:Scene3DContainer;
        private var trail:ShotTrail;
        private var trail1:ShotTrail;
        private var startPoint:Vector3 = new Vector3();
        private var direction:Vector3 = new Vector3();
        private var beginScale:Number;
        private var endScale:Number;
        private var moveDistance:Number;
        private var lifeTime:int;
        private var time:int;

        public function BeamEffect(param1:ObjectPool)
        {
            super(param1);
            this.trail = new ShotTrail();
            this.trail1 = new ShotTrail();
        }
        public function init(param1:Vector3, param2:Vector3, param3:Material, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:Material):void
        {
            this.startPoint.copyFrom(param1);
            this.direction.vDiff(param2, param1);
            var _loc9_:Number = this.direction.vLength();
            this.direction.scale((1 / _loc9_));
            this.beginScale = param5;
            this.endScale = param6;
            this.moveDistance = param7;
            this.lifeTime = param8;
            this.trail.init(param4 / 4, _loc9_, param3, param7);
            this.trail1.init(param4 * 1.275, _loc9_, param9, param7);
            this.time = 0;
        }
        public function play(param1:int, param2:GameCamera):Boolean
        {
            var _loc4_:Number;
            _loc4_ = NaN;
            var _loc3_:Number = NaN;
            _loc4_ = NaN;
            if (this.time > this.lifeTime)
            {
                return (false);
            }

            SFXUtils.alignObjectPlaneToView(this.trail, this.startPoint, this.direction, param2.pos);
            _loc3_ = (this.time / this.lifeTime);
            _loc4_ = Math.sqrt(_loc3_);
            this.trail.scaleX = (this.beginScale + ((this.endScale - this.beginScale) * _loc4_));
            this.trail.alpha = (1 - _loc3_ * 2);
            this.trail.update(_loc4_);

            SFXUtils.alignObjectPlaneToView(this.trail1, this.startPoint, this.direction, param2.pos);
            _loc3_ = (this.time / this.lifeTime);
            _loc4_ = Math.sqrt(_loc3_);
            this.trail1.scaleX = (this.beginScale + (this.endScale - this.beginScale) * _loc4_);
            this.trail1.alpha = (1 - _loc3_);
            this.trail1.update(_loc4_);

            this.time = (this.time + param1);
            return (true);
        }
        public function addToContainer(param1:Scene3DContainer):void
        {
            this.container = param1;
            param1.addChild(this.trail);
            param1.addChild(this.trail1);
        }
        public function destroy():void
        {
            this.trail.clear();
            this.trail1.clear();
            this.container.removeChild(this.trail);
            this.container.removeChild(this.trail1);
            // this.trail.destroy();
            this.container = null;
        }
        public function kill():void
        {
            this.time = (this.lifeTime + 1);
        }
        public function get owner():ClientObject
        {
            return (null);
        }

    }
}
