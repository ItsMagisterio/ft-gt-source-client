package alternativa.tanks.models.tank.explosion
{
   import alternativa.console.ConsoleVarInt;
   import alternativa.init.Main;
   import alternativa.object.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.vehicles.tanks.Tank;
   import alternativa.tanks.vehicles.tanks.TankSkin;

   public class TankDeathGraphicEffect implements IGraphicEffect
   {

      private static var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));

      private static var delay:ConsoleVarInt = new ConsoleVarInt("tankexpl_goffset", 110, 0, 2000);

      private var tankData:TankData;

      private var tank:Tank;

      private var skin:TankSkin;

      private var time:int;

      private var killed:Boolean;

      public function TankDeathGraphicEffect(tankData:TankData)
      {
         super();
         this.tankData = tankData;
         this.tankData.tank = tankData.tank;
         this.skin = tankData.tank.skin;
         this.tank = tankData.tank;
      }

      public function destroy():void
      {
         // this.tankData = null;
      }

      public function get owner():ClientObject
      {
         return null;
      }

      public function play(millis:int, camera:GameCamera):Boolean
      {
         if (this.killed)
         {
            return false;
         }
         if (this.time >= delay.value)
         {
            this.createEffects();
            return false;
         }
         this.time += millis;
         return true;
      }

      public function kill():void
      {
         this.killed = true;
      }

      public function addToContainer(container:Scene3DContainer):void
      {
         this.time = 0;
         this.killed = false;
      }

      private function createEffects():void
      {
         var tank:Tank = this.tankData.tank;
         if (tank == null)
         {
            return;
         }
         if (tank.skin.hullMesh.parent == null)
         {
            return;
         }
         tank.state.velocity.z += 500;
         tank.state.rotation.vReset(2, 2, 2);
         tank.skin.setDeadState();
         tank.skin.resetColorTransform();
         var explosionModel:TankExplosionModel = Main.osgi.getService(ITankExplosionModel) as TankExplosionModel;
         explosionModel.createExplosionEffects(this.tankData.hull, this.tankData);
      }
   }
}
