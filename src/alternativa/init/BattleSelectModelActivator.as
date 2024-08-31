package alternativa.init
{
    import alternativa.osgi.bundle.IBundleActivator;
    import alternativa.tanks.model.BattleSelectModel;
    import alternativa.service.IModelService;

    public class BattleSelectModelActivator implements IBundleActivator
    {

        public static var osgi:OSGi;

        public var battleSelectModel:BattleSelectModel;

        public function start(osgi:OSGi):void
        {
            BattleSelectModelActivator.osgi = osgi;
            var modelRegister:IModelService = (osgi.getService(IModelService) as IModelService);
            this.battleSelectModel = new BattleSelectModel();
            modelRegister.add(this.battleSelectModel);
        }
        public function stop(osgi:OSGi):void
        {
            var modelRegister:IModelService = (osgi.getService(IModelService) as IModelService);
            modelRegister.remove(this.battleSelectModel.id);
            this.battleSelectModel = null;
            BattleSelectModelActivator.osgi = null;
        }

    }
}
