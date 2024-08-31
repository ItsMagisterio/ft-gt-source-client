package alternativa.tanks.models.effects.firstaid
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.effects.firstaid.FirstAidModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.effects.firstaid.IFirstAidModelBase;
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;
    import alternativa.types.Long;

    public class FirstAidModel extends FirstAidModelBase implements IFirstAidModelBase
    {

        public function FirstAidModel()
        {
            _interfaces.push(IModel, IFirstAidModelBase);
        }
        public function activated(clientObject:ClientObject, tankId:Long):void
        {
        }

    }
}
