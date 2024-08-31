package alternativa.tanks.gui
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.init.Main;
   import alternativa.tanks.Tank3D;
   import alternativa.tanks.Tank3DPart;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.types.Long;
   import controls.TankWindowInner;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import forms.TankWindowWithHeader2;
   import logic.resource.ResourceType;
   import logic.resource.ResourceUtil;
   import logic.resource.images.ImageResource;
   import logic.resource.tanks.TankResource;
   import specter.utils.Logger;
   import alternativa.engine3d.core.Shadow;
   import alternativa.engine3d.core.Vertex;

   public class TankPreview extends Sprite
   {

      private static const ENTER_FRAME_PRIORITY:Number = -1;

      private static const INITIAL_CAMERA_DIRECTION:Number = -150;

      private static const WINDOW_MARGIN:int = 11;

      private static const SHADOW_ALPHA:Number = 0.7;

      private static const SHADOW_BLUR:Number = 13;

      private static const SHADOW_RESOLUTION:Number = 2.5;

      private static const SHADOW_DIRECTION:Vector3D = new Vector3D(0, 0, -1);

      private const windowMargin:int = 11;

      private var window:TankWindowWithHeader2;

      private var inner:TankWindowInner;

      private var rootContainer:Object3DContainer;

      private var cameraContainer:Object3DContainer;

      private var garageMeshContainer:Object3DContainer = new Object3DContainer();

      private var camera:GameCamera;

      private var timer:Timer;

      private var tank:Tank3D;

      private var rotationSpeed:Number;

      private var lastTime:int;

      private var loadedCounter:int = 0;

      private var holdMouseX:int;

      private var lastMouseX:int;

      private var prelastMouseX:int;

      private var rate:Number;

      private var startAngle:Number = -150;

      private var holdAngle:Number;

      private var slowdownTimer:Timer;

      private var resetRateInt:uint;

      private var autoRotationDelay:int = 10000;

      private var autoRotationTimer:Timer;

      public var overlay:Shape;

      private var firstAutoRotation:Boolean = true;

      private var first_resize:Boolean = true;

      public function TankPreview(garageBoxId:Long, rotationSpeed:Number = 5)
      {
         this.overlay = new Shape();
         super();
         this.rotationSpeed = rotationSpeed;
         this.window = new TankWindowWithHeader2("YOUR TANK");
         addChild(this.window);
         this.rootContainer = new KDContainer();
         var boxResource:TankResource = ResourceUtil.getResource(ResourceType.MODEL, "garage_box_model") as TankResource;
         Main.writeVarsToConsoleChannel("TANK PREVIEW", "\tgarageBoxId: %1", garageBoxId);
         Main.writeVarsToConsoleChannel("TANK PREVIEW", "\tboxResource: %1", boxResource);
         var boxes:Vector.<Mesh> = new Vector.<Mesh>();
         var numObjects:int = int(boxResource.objects.length);
         Logger.log("Garage: " + numObjects + " " + boxResource.id);
         this.initGarage();
         this.tank = new Tank3D(null, null, null);
         this.rootContainer.addChild(this.tank);
         this.tank.matrix.appendTranslation(0, 0, 130);
         this.camera = new GameCamera();
         this.camera.view = new View(100, 100, false);
         this.camera.view.hideLogo();
         this.camera.useShadowMap = true;
         this.camera.useLight = true;
         addChild(this.camera.view);
         addChild(this.overlay);
         this.overlay.x = 0;
         this.overlay.y = 9;
         this.overlay.width = 1500;
         this.overlay.height = 1300;
         this.overlay.graphics.clear();
         this.cameraContainer = new Object3DContainer();
         this.rootContainer.addChild(this.cameraContainer);
         this.cameraContainer.addChild(this.camera);
         this.camera.z = -950;
         this.tank.z = 0;
         this.garageMeshContainer.z = -130;
         this.cameraContainer.rotationX = -110 * Math.PI / 180;
         this.cameraContainer.rotationZ = this.startAngle * Math.PI / 180;
         this.inner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
         addChild(this.inner);
         this.inner.mouseEnabled = true;
         this.resize(400, 300);
         this.autoRotationTimer = new Timer(this.autoRotationDelay, 1);
         this.autoRotationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.start);
         this.timer = new Timer(50);
         this.slowdownTimer = new Timer(20, 1000000);
         this.slowdownTimer.addEventListener(TimerEvent.TIMER, this.slowDown);
         this.inner.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
         Main.stage.addEventListener(Event.ENTER_FRAME, this.onRender, false, 0, false);
         this.start();
      }

      private function initGarageOld():void
      {
      }

      private function initGarage():void
      {
         this.rootContainer.addChild(createSkyBox());
         var obj:Object3D = null;
         var mesh:Mesh = null;
         var bytes:TankResource = ResourceUtil.getResource(ResourceType.MODEL, "garage_box_model") as TankResource;
         var tree:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img1").bitmapData;
         var obj1:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img3").bitmapData;
         var obj2:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img4a").bitmapData;
         var obj3:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img6").bitmapData;
         var obj4:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img8").bitmapData;
         var obj5:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img9").bitmapData;
         var obj6:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img10").bitmapData;
         var obj7:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img11").bitmapData;
         var tower:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, "garage_box_img12").bitmapData;
         var treeMaterial:TextureMaterial = new TextureMaterial(tree, true, false, 1, 1);
         var obj1m:TextureMaterial = new TextureMaterial(obj1, true, false);
         var obj2m:TextureMaterial = new TextureMaterial(obj2, true, false, 1, 1);
         var obj3m:TextureMaterial = new TextureMaterial(obj3, true, false, 1, 1);
         var obj4m:TextureMaterial = new TextureMaterial(obj4, true, false, 1, 1);
         var obj5m:TextureMaterial = new TextureMaterial(obj5, true, false);
         var obj6m:TextureMaterial = new TextureMaterial(obj6, true, false, 1, 1);
         var obj7m:TextureMaterial = new TextureMaterial(obj7, true, false, 1, 1);
         var towerM:TextureMaterial = new TextureMaterial(tower, true, false, 1, 1);
         for each (obj in bytes.objects)
         {
            mesh = obj as Mesh;
            if (obj.name.indexOf("tree") >= 0)
            {
               mesh.setMaterialToAllFaces(treeMaterial);
            }
            if (obj.name == "Tower")
            {
               mesh.setMaterialToAllFaces(towerM);
            }
            if (obj.name == "bg2")
            {
               mesh.setMaterialToAllFaces(obj7m);
            }
            if (obj.name == "bg")
            {
               mesh.setMaterialToAllFaces(obj7m);
            }
            if (obj.name.indexOf("wall_") >= 0)
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if (obj.name == "wall_10")
            {
               mesh.setMaterialToAllFaces(obj2m);
            }
            if (obj.name == "Object20")
            {
               mesh.setMaterialToAllFaces(obj2m);
            }
            if (obj.name == "Object06")
            {
               mesh.setMaterialToAllFaces(obj6m);
            }
            if (obj.name == "pandus_2")
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if (obj.name == "girders")
            {
               mesh.setMaterialToAllFaces(obj2m);
            }
            if (obj.name == "pandus_1")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "Object105")
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if (obj.name == "Object104")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "Object79")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "Object10" || obj.name == "Object11" || obj.name == "Object12" || obj.name == "Object13")
            {
               mesh.setMaterialToAllFaces(obj1m);
            }
            if (obj.name == "Object05")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "Object40" || obj.name == "Object41" || obj.name == "Object42" || obj.name == "Object43" || obj.name == "Object36" || obj.name == "Object37" || obj.name == "Object38" || obj.name == "Object81" || obj.name == "Object80" || obj.name == "Object38")
            {
               mesh.setMaterialToAllFaces(obj4m);
            }
            if (obj.name == "Object25" || obj.name == "Object26")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "wall_8")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "wall_6")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "Object23" || obj.name == "Object25" || obj.name == "Object24" || obj.name == "Object22")
            {
               mesh.setMaterialToAllFaces(obj5m);
            }
            if (obj.name == "Object04")
            {
               mesh.setMaterialToAllFaces(obj4m);
            }
            if (obj.name == "Object92" || obj.name == "Object95" || obj.name == "Object89" || obj.name == "Object84" || obj.name == "Object85" || obj.name == "Object88" || obj.name == "Object91" || obj.name == "Object141" || obj.name == "Object142" || obj.name == "Object88" || obj.name == "Object94" || obj.name == "Object93" || obj.name == "Object90" || obj.name == "Object96" || obj.name == "Object02")
            {
               mesh.setMaterialToAllFaces(obj2m);
            }
            if (obj.name == "Object56" || obj.name == "Object57" || obj.name == "Object54" || obj.name == "Object136" || obj.name == "Object146" || obj.name == "Object45" || obj.name == "Object58" || obj.name == "Object49" || obj.name == "Object82" || obj.name == "Object69" || obj.name == "Object70" || obj.name == "Object68" || obj.name == "Object67" || obj.name == "Object77" || obj.name == "Object78" || obj.name == "Object59" || obj.name == "Object60")
            {
               mesh.setMaterialToAllFaces(obj4m);
            }
            mesh.x = 70;
            mesh.useShadowMap = true;
            mesh.shadowMapAlphaThreshold = 2;
            mesh.depthMapAlphaThreshold = 2;
            this.garageMeshContainer.addChild(mesh);
         }
         this.rootContainer.addChild(this.garageMeshContainer);
      }

      private function createSkyBox():SkyBox
      {
         var material:TextureMaterial = new TextureMaterial(ResourceUtil.getResource(ResourceType.IMAGE, "skybox2_1").bitmapData);
         var skyBox:SkyBox = new SkyBox(200000, material, material, material, material, material, material);
         // var m:Matrix = new Matrix();
         // var sides:Array = [SkyBox.RIGHT,SkyBox.BACK,SkyBox.LEFT,SkyBox.FRONT];
         // for(var i:int = 0; i < sides.length; i++)
         // {
         // m.identity();
         // m.scale(1 / 6,1);
         // m.translate(i / 6.01,0);
         // skyBox.transformUV(sides[i],m);
         // }
         // m.identity();
         // m.scale(-1 / 6.01,-1);
         // m.translate(5 / 6,1);
         // skyBox.transformUV(SkyBox.TOP,m);
         // m.identity();
         // m.scale(-1 / 6.01,-1);
         // m.translate(1,1);
         // skyBox.transformUV(SkyBox.BOTTOM,m);
         return skyBox;
      }

      public function hide():void
      {
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if (bgService != null)
         {
            bgService.drawBg();
         }
         this.stopAll();
         this.window = null;
         this.inner = null;
         this.rootContainer = null;
         this.cameraContainer = null;
         this.camera = null;
         this.timer = null;
         this.tank = null;
         Main.stage.removeEventListener(Event.ENTER_FRAME, this.onRender);
      }

      private function onMouseDown(e:MouseEvent):void
      {
         if (this.autoRotationTimer.running)
         {
            this.autoRotationTimer.stop();
         }
         if (this.timer.running)
         {
            this.stop();
         }
         if (this.slowdownTimer.running)
         {
            this.slowdownTimer.stop();
         }
         this.resetRate();
         this.holdMouseX = Main.stage.mouseX;
         this.lastMouseX = this.holdMouseX;
         this.prelastMouseX = this.holdMouseX;
         this.holdAngle = this.cameraContainer.rotationZ;
         Main.writeToConsole("TankPreview onMouseMove holdAngle: " + this.holdAngle.toString());
         Main.stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
         Main.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
      }

      private function onMouseMove(e:MouseEvent):void
      {
         this.cameraContainer.rotationZ = this.holdAngle - (Main.stage.mouseX - this.holdMouseX) * 0.01;
         this.camera.render();
         this.rate = (Main.stage.mouseX - this.prelastMouseX) * 0.5;
         this.prelastMouseX = this.lastMouseX;
         this.lastMouseX = Main.stage.mouseX;
         clearInterval(this.resetRateInt);
         this.resetRateInt = setInterval(this.resetRate, 50);
      }

      private function resetRate():void
      {
         this.rate = 0;
      }

      private function onMouseUp(e:MouseEvent):void
      {
         clearInterval(this.resetRateInt);
         Main.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
         Main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
         if (Math.abs(this.rate) > 0)
         {
            this.slowdownTimer.reset();
            this.slowdownTimer.start();
         }
         else
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }

      private function slowDown(e:TimerEvent):void
      {
         this.cameraContainer.rotationZ -= this.rate * 0.01;
         this.camera.render();
         this.rate *= Math.exp(-0.02);
         if (Math.abs(this.rate) < 0.1)
         {
            this.slowdownTimer.stop();
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }

      public function setHull(hull:String):void
      {
         if (hull.indexOf("HD_") != -1)
         {
            hull = hull.replace("HD_", "");
         }
         var hullPart:Tank3DPart = new Tank3DPart();
         hullPart.details = ResourceUtil.getResource(ResourceType.IMAGE, hull + "_details").bitmapData;
         hullPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE, hull + "_lightmap").bitmapData;
         hullPart.mesh = ResourceUtil.getResource(ResourceType.MODEL, hull).mesh;
         hullPart.objects = ResourceUtil.getResource(ResourceType.MODEL, hull).objects;
         hullPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL, hull).turretMount;
         this.tank.setHull(hullPart);
         if (this.loadedCounter < 3)
         {
            ++ this.loadedCounter;
         }
         if (this.loadedCounter == 3)
         {
            if (this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
         this.camera.addShadow(this.tank.shadow);
      }

      public function setTurret(turret:String):void
      {
         var turretPart:Tank3DPart = new Tank3DPart();
         turretPart.details = ResourceUtil.getResource(ResourceType.IMAGE, turret + "_details").bitmapData;
         turretPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE, turret + "_lightmap").bitmapData;
         if (turret.indexOf("HD_") != -1)
         {
            turret = turret.replace("HD_", "");
         }
         turretPart.mesh = ResourceUtil.getResource(ResourceType.MODEL, turret).mesh;
         turretPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL, turret).turretMount;
         this.tank.setTurret(turretPart);
         if (this.loadedCounter < 3)
         {
            ++ this.loadedCounter;
         }
         if (this.loadedCounter == 3)
         {
            if (this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }

      public function setColorMap(map:ImageResource):void
      {
         this.tank.setColorMap(map);
         if (this.loadedCounter < 3)
         {
            ++ this.loadedCounter;
         }
         if (this.loadedCounter == 3)
         {
            if (this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }

      public function setResistance(map:ImageResource):void
      {
         if (this.loadedCounter < 3)
         {
            ++ this.loadedCounter;
         }
         if (this.loadedCounter == 3)
         {
            if (this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }

      public function resize(width:Number, height:Number, i:int = 0, j:int = 0):void
      {
         this.window.width = width;
         this.window.height = height;
         this.window.alpha = 1;
         this.inner.width = width - this.windowMargin * 2;
         this.inner.height = height - this.windowMargin * 2;
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if (Main.stage.stageWidth >= 800 && !this.first_resize)
         {
            if (bgService != null)
            {
               bgService.drawBg(new Rectangle(Math.round(int(Math.max(1000, Main.stage.stageWidth)) / 3) + this.windowMargin, 60 + this.windowMargin, this.inner.width, this.inner.height));
            }
         }
         this.first_resize = false;
         this.camera.view.width = width - this.windowMargin * 2 - 2;
         this.camera.view.height = height - this.windowMargin * 2 - 2;
         this.camera.view.x = this.windowMargin;
         this.camera.view.y = this.windowMargin;
         this.camera.render();
      }

      public function start(e:TimerEvent = null):void
      {
         if (this.loadedCounter < 3)
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
         else
         {
            this.firstAutoRotation = false;
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.timer.reset();
            this.lastTime = getTimer();
            this.timer.start();
         }
      }

      public function onRender(e:Event):void
      {
         this.camera.render();
      }

      public function stop():void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
      }

      public function stopAll():void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
         this.slowdownTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER, this.slowDown);
         this.autoRotationTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.start);
      }

      private function onTimer(e:TimerEvent):void
      {
         var time:int = this.lastTime;
         this.lastTime = getTimer();
         this.cameraContainer.rotationZ -= this.rotationSpeed * (this.lastTime - time) * 0.0003 * (Math.PI / 180);
      }
   }
}
