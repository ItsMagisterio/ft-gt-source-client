﻿package alternativa.init
{
    import alternativa.osgi.bundle.IBundleActivator;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.osgi.service.storage.IStorageService;
    import flash.net.SharedObject;
    import alternativa.tanks.services.materialregistry.impl.DebugMaterialRegistry;
    import alternativa.tanks.services.materialregistry.impl.MaterialRegistry;
    import alternativa.tanks.model.panel.IBattleSettings;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.services.objectpool.impl.ObjectPoolService;
    import alternativa.tanks.models.tank.ITankEventDispatcher;
    import alternativa.tanks.models.tank.TankEventDispatcher;

    public class BattlefieldSharedActivator implements IBundleActivator
    {

        public function start(osgi:OSGi):void
        {
            var materialRegistry:IMaterialRegistry;
            var storage:SharedObject = IStorageService(osgi.getService(IStorageService)).getStorage();
            if (storage.data.textureDebug)
            {
                materialRegistry = new DebugMaterialRegistry();
            }
            else
            {
                materialRegistry = new MaterialRegistry(osgi);
            }
            var battleSettings:IBattleSettings = IBattleSettings(osgi.getService(IBattleSettings));
            materialRegistry.useMipMapping = battleSettings.enableMipMapping;
            osgi.registerService(IMaterialRegistry, materialRegistry);
            osgi.registerService(IObjectPoolService, new ObjectPoolService());
            osgi.registerService(ITankEventDispatcher, new TankEventDispatcher());
        }
        public function stop(osgi:OSGi):void
        {
            osgi.unregisterService(IMaterialRegistry);
            osgi.unregisterService(IObjectPoolService);
            osgi.unregisterService(ITankEventDispatcher);
        }

    }
}
