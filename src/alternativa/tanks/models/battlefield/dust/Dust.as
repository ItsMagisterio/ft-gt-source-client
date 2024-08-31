package alternativa.tanks.models.battlefield.dust
{
    import alternativa.math.Vector3;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.engine3d.TextureAnimation;
    import flash.utils.Dictionary;
    import alternativa.tanks.camera.GameCamera;
    import alternativa.tanks.utils.GraphicsUtils;
    import flash.display.BitmapData;
    import alternativa.tanks.models.tank.TankData;
    import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
    import alternativa.tanks.vehicles.tanks.Track;
    import alternativa.math.Matrix3;
    import alternativa.tanks.vehicles.tanks.SuspensionRay;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.tanks.sfx.ScalingObject3DPositionProvider;
    import alternativa.tanks.sfx.LimitedDistanceAnimatedSpriteEffect;
    import flash.display.BlendMode;
    import alternativa.tanks.model.panel.IBattleSettings;
    import alternativa.init.Main;

    public class Dust
    {

        private static const CHANCE:Number = 0.2;
        private static const SCALE_JITTER:Number = 1;
        private static const bias:Vector3 = new Vector3(100, 0, 0);
        private static const particleVelocity:Vector3 = new Vector3();
        private static const particlePosition:Vector3 = new Vector3();

        private var battleService:BattlefieldModel;
        private var dustSize:Number = 0;
        private var animation:TextureAnimation;
        private var tanks:Dictionary = new Dictionary();
        private var camera:GameCamera;
        private var nearDistance:Number;
        private var farDistance:Number;
        public var enabled:Boolean = true;
        private var intensity:Number;
        private var density:Number;

        public function Dust(param1:BattlefieldModel)
        {
            this.battleService = param1;
            this.camera = param1.bfData.viewport.camera;
            var settings:IBattleSettings = (IBattleSettings(Main.osgi.getService(IBattleSettings)));
            // if(settings.useSoftParticle){
            this.camera.softAttenuation = 120;
            this.camera.softTransparency = true;
            // }
        }
        private static function addJitter(param1:Vector3, param2:Number):void
        {
            param1.x = (param1.x + (((Math.random() - 0.5) * 2) * param2));
            param1.y = (param1.y + (((Math.random() - 0.5) * 2) * param2));
            param1.z = (param1.z + (((Math.random() - 0.5) * 2) * param2));
        }

        public function init(param1:BitmapData, farDistance:Number, nearDistance:Number, dustSize:Number, intensity:Number, density:Number):void
        {
            this.farDistance = farDistance;
            this.nearDistance = nearDistance;
            this.dustSize = dustSize;
            this.intensity = intensity;
            this.density = density;
            this.animation = GraphicsUtils.getTextureAnimation(null, param1, 32, 32);
            this.animation.fps = 30;
        }
        public function addTank(param1:TankData):void
        {
            this.tanks[param1] = (param1.tank.getBoundSphereRadius() / 600);
        }
        public function removeTank(param1:TankData):void
        {
            delete this.tanks[param1];
        }
        public function update():void
        {
            var _loc1_:* = undefined;
            var _loc2_:TankData;
            if ((((this.enabled) && (this.camera.softTransparency)) && (this.camera.softTransparencyStrength > 0)))
            {
                for (_loc1_ in this.tanks)
                {
                    _loc2_ = (_loc1_ as TankData);
                    if ((((_loc2_) && (_loc2_.spawnState == TankSpawnState.ACTIVE)) && (this.battleService.bfData.activeTanks[_loc2_])))
                    {
                        this.addTankDust(_loc2_, 100, this.density);
                    }
                }
            }
        }
        public function addTankDust(param1:TankData, param2:Number = 100, param3:Number = 0.2):void
        {
            var _loc6_:Track;
            _loc6_ = null;
            var _loc4_:Number = this.tanks[param1];
            var _loc5_:Track = param1.tank.leftTrack;
            _loc6_ = param1.tank.rightTrack;
            if ((param1.tank.leftThrottle * param1.tank.rightThrottle) < 0)
            {
                param2 = 5;
            }
            var _loc7_:Matrix3 = param1.tank.baseMatrix;
            bias.x = (bias.x * -1);
            _loc7_.transformVector(bias, particleVelocity);
            this.addTrackDust(param1.tank, _loc5_, _loc4_, particleVelocity, param2, param3, param1.tank.leftThrottle);
            bias.x = (bias.x * -1);
            _loc7_.transformVector(bias, particleVelocity);
            this.addTrackDust(param1.tank, _loc6_, _loc4_, particleVelocity, param2, param3, param1.tank.rightThrottle);
        }
        private function addTrackDust(tank:Tank, param1:Track, param2:Number, param3:Vector3, param4:Number, param5:Number, trackSpeed:Number):void
        {
            var _loc7_:SuspensionRay = null;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc6_:int = 0;
            while (_loc6_ < param1.raysNum)
            {
                _loc7_ = param1.rays[_loc6_];
                _loc8_ = _loc7_.speed;
                if (_loc8_ > param4 && Math.random() < param5)
                {
                    _loc9_ = _loc8_ > 500 ? 1 : 0.3 + _loc8_ / 712;
                    particlePosition.copy(_loc7_.getGlobalOrigin());
                    addJitter(particlePosition, 50);
                    param3.z = 100;
                    addJitter(param3, 20);
                    this.createDustParticle(tank, param2, particlePosition, param3, _loc9_);
                }
                _loc6_++;
            }
        }
        private function createDustParticle(tank:Tank, param1:Number, param2:Vector3, param3:Vector3, param4:Number):void
        {
            var _loc5_:ScalingObject3DPositionProvider;
            var _loc6_:LimitedDistanceAnimatedSpriteEffect;
            var _loc7_:Number = NaN;
            if ((((this.enabled) && (this.camera.softTransparency)) && (this.camera.softTransparencyStrength > 0)))
            {
                _loc5_ = ScalingObject3DPositionProvider(this.battleService.getObjectPool().getObject(ScalingObject3DPositionProvider));
                _loc5_.init(param2, param3, 0.01);
                _loc6_ = LimitedDistanceAnimatedSpriteEffect(this.battleService.getObjectPool().getObject(LimitedDistanceAnimatedSpriteEffect));
                _loc7_ = ((this.dustSize * param1) * (1 + (SCALE_JITTER * Math.random())));
                _loc6_.init(_loc7_, _loc7_, this.animation, ((Math.random() * 2) * Math.PI), _loc5_, 0.5, 0.5, null, 130, BlendMode.NORMAL, this.nearDistance, this.farDistance, 0.7, true);
                this.battleService.addGraphicEffect(_loc6_);
            }
        }

    }
}
