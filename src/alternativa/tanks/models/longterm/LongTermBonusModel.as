package alternativa.tanks.models.longterm
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.common.longterm.LongTermBonusModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.common.longterm.ILongTermBonusModelBase;
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;
    import alternativa.types.Long;

    public class LongTermBonusModel extends LongTermBonusModelBase implements ILongTermBonusModelBase
    {

        public function LongTermBonusModel()
        {
            _interfaces.push(IModel, ILongTermBonusModelBase);
        }
        public function effectStart(clientObject:ClientObject, tankId:Long, durationSec:int):void
        {
        }
        public function effectStop(clientObject:ClientObject, tankId:Long):void
        {
        }

    }
}
