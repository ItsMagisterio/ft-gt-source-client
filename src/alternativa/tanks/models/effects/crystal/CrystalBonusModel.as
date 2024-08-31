package alternativa.tanks.models.effects.crystal
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.effects.crystal.CrystalBonusModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.effects.crystal.ICrystalBonusModelBase;
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;
    import alternativa.types.Long;

    public class CrystalBonusModel extends CrystalBonusModelBase implements ICrystalBonusModelBase
    {

        public function CrystalBonusModel()
        {
            _interfaces.push(IModel, ICrystalBonusModelBase);
        }
        public function activated(clientObject:ClientObject, tankId:Long, crystals:int):void
        {
        }

    }
}
