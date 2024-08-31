package alternativa.tanks.models.battlefield.gamemode
{
    import alternativa.tanks.camera.GameCamera;
    import alternativa.engine3d.lights.DirectionalLight;
    import alternativa.engine3d.core.ShadowMap;
    import alternativa.tanks.models.battlefield.BattleView3D;
    import alternativa.osgi.service.storage.IStorageService;
    import alternativa.init.Main;
    import alternativa.tanks.model.panel.IBattleSettings;
    import flash.display.BitmapData;
    import flash.display.Bitmap;

    public class FogGameMode implements IGameMode
    {

        private var camera:GameCamera;

        public function applyChanges(viewport:BattleView3D):void
        {
            var light:DirectionalLight;
            var camera:GameCamera;
            light = null;
            camera = null;
            light = null;
            camera = viewport.camera;
            this.camera = camera;
            camera.directionalLightStrength = Number(1);
            camera.ambientColor = 2304312;
            camera.deferredLighting = true;
            var dirLightColor:int = 2105382;
            light = new DirectionalLight(dirLightColor);
            light.useShadowMap = true;
            var x:Number = -1;
            var z:Number = -0.9;
            light.rotationX = Number(-4.420796);
            light.rotationY = Number(0);
            light.rotationZ = Number(3.5);
            light.intensity = Number(1.1);
            camera.directionalLight = light;
            camera.shadowMap = new ShadowMap(0x0800, 5000, 15000, 0, 0);
            camera.shadowMapStrength = Number(0.8);
            camera.shadowMap.bias = Number(0.8);
            camera.shadowMap.biasMultiplier = Number(30);
            camera.shadowMap.additionalSpace = Number(10000);
            camera.shadowMap.alphaThreshold = Number(0.1);
            camera.useShadowMap = true;
            camera.ssao = true;
            camera.ssaoRadius = Number(400);
            camera.ssaoRange = Number(450);
            camera.ssaoColor = 0;
            camera.ssaoAlpha = Number(1.5);
        }
        public function applyChangesBeforeSettings(settings:IBattleSettings):void
        {
            if (((settings.fog) && (!(this.camera.fogStrength == 1))))
            {
                this.camera.fogStrength = Number(1);
            }
            else
            {
                if ((!(settings.fog)))
                {
                    this.camera.fogStrength = Number(0);
                }
            }
            if (((settings.shadows) && (!(this.camera.useShadowMap))))
            {
                this.camera.useShadowMap = true;
                if (this.camera.directionalLight != null)
                {
                    this.camera.directionalLight.useShadowMap = true;
                }
                this.camera.shadowMapStrength = Number(1);
            }
            else
            {
                if ((!(settings.shadows)))
                {
                    this.camera.useShadowMap = false;
                    if (this.camera.directionalLight != null)
                    {
                        this.camera.directionalLight.useShadowMap = false;
                    }
                    this.camera.shadowMapStrength = Number(0);
                }
            }
            if (((settings.defferedLighting) && (!(this.camera.directionalLightStrength == 1))))
            {
                this.camera.directionalLight.intensity = Number(1.1);
                this.camera.directionalLightStrength = Number(1);
                this.camera.deferredLighting = true;
                this.camera.deferredLightingStrength = Number(1);
            }
            else
            {
                if ((!(settings.defferedLighting)))
                {
                    this.camera.directionalLight.intensity = Number(0);
                    this.camera.directionalLightStrength = Number(0);
                    this.camera.deferredLighting = false;
                    this.camera.deferredLightingStrength = Number(0);
                }
            }
            if (IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_ssao"] != null)
            {
                this.camera.ssao = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_ssao"];
            }
            else
            {
                this.camera.ssao = false;
            }
        }
        public function applyColorchangesToSkybox(skybox:BitmapData):BitmapData
        {
            var btm:BitmapData = new BitmapData(1, 1, false, (1382169 + 7559484));
            skybox.colorTransform(skybox.rect, new Bitmap(btm).transform.colorTransform);
            return (skybox);
        }

    }
}
