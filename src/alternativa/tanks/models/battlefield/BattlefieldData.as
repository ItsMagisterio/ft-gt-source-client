package alternativa.tanks.models.battlefield
{
    import alternativa.object.ClientObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import alternativa.physics.PhysicsScene;
    import alternativa.tanks.physics.TanksCollisionDetector;
    import alternativa.engine3d.objects.SkyBox;

    public class BattlefieldData
    {

        public var bfObject:ClientObject;
        public var localUser:ClientObject;
        public var guiContainer:DisplayObjectContainer;
        public var viewport:BattleView3D;
        public var tanks:Dictionary = new Dictionary();
        public var activeTanks:Dictionary = new Dictionary();
        public var graphicEffects:Dictionary = new Dictionary();
        public var bonuses:Dictionary = new Dictionary();
        public var bonusTakenSound:Sound;
        public var battleFinishSound:Sound;
        public var ambientSound:Sound;
        public var ambientChannel:SoundChannel;
        public var killSound:Sound;
        public var physicsScene:PhysicsScene;
        public var collisionDetector:TanksCollisionDetector;
        public var physTime:int;
        public var time:int;
        public var skybox:SkyBox;
        public var respawnInvulnerabilityPeriod:int;
        public var idleKickPeriod:int;

    }
}
