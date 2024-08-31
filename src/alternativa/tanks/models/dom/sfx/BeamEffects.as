package alternativa.tanks.models.dom.sfx
{
    import flash.utils.Dictionary;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.object.ClientObject;
    import alternativa.tanks.sfx.IGraphicEffect;

    public class BeamEffects
    {

        private var effects:Dictionary;
        private var battleService:BattlefieldModel;

        public function BeamEffects(battleService:BattlefieldModel)
        {
            this.effects = new Dictionary();
            this.battleService = battleService;
        }
        public function addEffect(param1:ClientObject, param2:IGraphicEffect):void
        {
            this.effects[param1] = param2;
            this.battleService.addGraphicEffect(param2);
        }
        public function removeEffect(param1:ClientObject):void
        {
            var _loc2_:IGraphicEffect = this.effects[param1];
            if (_loc2_ != null)
            {
                _loc2_.kill();
                delete this.effects[param1];
            }
        }
        public function removeAllEffects():void
        {
            var _loc2_:IGraphicEffect = null;
            for each (_loc2_ in this.effects)
            {
                _loc2_.kill();
            }
        }

    }
}
