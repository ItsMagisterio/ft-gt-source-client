package alternativa.tanks.models.battlefield.gamemode
{
	import alternativa.tanks.camera.GameCamera;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.init.Main;
	import alternativa.tanks.models.battlefield.IBattleField;
	import alternativa.tanks.models.battlefield.BattlefieldModel;
	import alternativa.engine3d.core.ShadowMap;
	import alternativa.tanks.models.battlefield.BattleView3D;
	import alternativa.osgi.service.storage.IStorageService;
	import alternativa.tanks.model.panel.IBattleSettings;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	public class DayGameMode implements IGameMode
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
			camera.directionalLightStrength = 1;
			camera.ambientColor = 5530735;
			camera.deferredLighting = true;
			var dirLightColor:int = 7559484;
			camera.fogNear = 5000;
			camera.fogFar = 10000;
			camera.fogColor = 10543615;
			camera.fogAlpha = 0.25;
			camera.fogStrength = 1;
			camera.ssaoColor = 2636880;
			if ((Main.osgi.getService(IBattleField) as BattlefieldModel).mapResourceId.indexOf("_winter") != -1)
			{
				camera.ambientColor = 0x5E5E5E;
				dirLightColor = 2235413;
			}
			if ((Main.osgi.getService(IBattleField) as BattlefieldModel).mapResourceId.indexOf("iran") != -1)
			{
				camera.ambientColor = 4016978;
				dirLightColor = 0x574341;
				camera.fogNear = 5000;
				camera.fogFar = 10000;
				camera.fogColor = 15124897;
				camera.fogAlpha = 0.699999988079071;
				camera.fogStrength = 1;
				camera.ssaoColor = 2045258;
			}
			light = new DirectionalLight(dirLightColor);
			light.useShadowMap = true;
			var x:Number = -1;
			var z:Number = -0.9;
			light.rotationX = 2.420796;
			light.rotationY = 0;
			light.rotationZ = 2.5;
			light.intensity = 1;
			camera.directionalLight = light;
			camera.shadowMap = new ShadowMap(0x0800, 5000, 10000, 0, 0);
			camera.shadowMapStrength = 1;
			camera.shadowMap.bias = 0.5;
			camera.shadowMap.biasMultiplier = 30;
			camera.shadowMap.additionalSpace = 10000;
			camera.shadowMap.alphaThreshold = 0.2;
			camera.useShadowMap = true;
			camera.ssao = true;
			camera.ssaoRadius = 400;
			camera.ssaoRange = 1200;
			camera.ssaoAlpha = 1.4;
		}

		public function applyChangesBeforeSettings(settings:IBattleSettings):void
		{
			if (((settings.fog) && (!(this.camera.fogStrength == 1))))
			{
				this.camera.fogStrength = 1;
			}
			else
			{
				if ((!(settings.fog)))
				{
					this.camera.fogStrength = 0;
				}

			}
			if (((settings.defferedLighting)))
			{

				this.camera.deferredLighting = true;
				this.camera.deferredLightingStrength = 1;
			}
			else
			{
				if ((!(settings.defferedLighting)))
				{

					this.camera.deferredLighting = false;
					this.camera.deferredLightingStrength = 0;
				}

			}
			;
			if (((settings.shadows)))
			{
				this.camera.useShadowMap = true;
				if (this.camera.directionalLight != null)
				{
					this.camera.directionalLight.useShadowMap = true;
					this.camera.directionalLight.intensity = 1;
					this.camera.directionalLightStrength = 1;
				}

				this.camera.shadowMapStrength = 1;
			}
			else
			{
				if ((!(settings.shadows)))
				{
					this.camera.useShadowMap = false;

					if (this.camera.directionalLight != null)
					{
						this.camera.directionalLight.intensity = 0.5;

						this.camera.directionalLightStrength = 1;
						this.camera.directionalLight.useShadowMap = false;
					}
					this.camera.shadowMapStrength = 0;
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
