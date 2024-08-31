package alternativa.osgi
{
    import alternativa.osgi.bundle.IBundleActivator;
    import __AS3__.vec.Vector;
    import alternativa.model.IModel;
    import alternativa.init.OSGi;
    import alternativa.service.IModelService;
    import __AS3__.vec.*;

    public class CommonBundleActivator implements IBundleActivator
    {

        protected var models:Vector.<IModel> = new Vector.<IModel>();

        public function start(osgi:OSGi):void
        {
        }
        public function stop(osgi:OSGi):void
        {
            var model:IModel;
            var bundleListener:IBundleListener;
            var modelService:IModelService = IModelService(osgi.getService(IModelService));
            while ((model = this.models.pop()) != null)
            {
                bundleListener = (model as IBundleListener);
                if (bundleListener != null)
                {
                    bundleListener.bundleStop();
                }
                modelService.remove(model.id);
            }
        }
        protected function registerModel(model:IModel, osgi:OSGi):void
        {
            var modelService:IModelService = IModelService(osgi.getService(IModelService));
            modelService.add(model);
            this.models.push(model);
            var bundleListener:IBundleListener = (model as IBundleListener);
            if (bundleListener != null)
            {
                bundleListener.bundleStart();
            }
        }

    }
}
