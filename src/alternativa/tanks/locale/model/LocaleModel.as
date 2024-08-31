package alternativa.tanks.locale.model
{
    import com.alternativaplatform.client.models.core.users.model.localized.LocalizedModelBase;
    import com.alternativaplatform.client.models.core.users.model.localized.ILocalizedModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;

    public class LocaleModel extends LocalizedModelBase implements ILocalizedModelBase, IObjectLoadListener
    {

        public function LocaleModel()
        {
            _interfaces.push(IModel);
            _interfaces.push(ILocalizedModelBase);
            _interfaces.push(IObjectLoadListener);
        }
        public function objectLoaded(object:ClientObject):void
        {
        }
        public function objectUnloaded(object:ClientObject):void
        {
        }

    }
}
