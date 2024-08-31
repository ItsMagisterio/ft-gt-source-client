package alternativa.tanks.model
{
    import com.alternativaplatform.projects.tanks.client.garage.effects.effectableitem.EffectableItemModelBase;
    import com.alternativaplatform.projects.tanks.client.garage.effects.effectableitem.IEffectableItemModelBase;
    import alternativa.service.IModelService;
    import flash.utils.Dictionary;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import __AS3__.vec.Vector;

    public class ItemEffectModel extends EffectableItemModelBase implements IEffectableItemModelBase, IItemEffect
    {

        private var modelRegister:IModelService;
        private var remainingTime:Dictionary;
        private var idByTimer:Dictionary;

        public function ItemEffectModel()
        {
            _interfaces.push(IModel);
            _interfaces.push(IItemEffect);
            _interfaces.push(IEffectableItemModelBase);
            this.remainingTime = new Dictionary();
            this.idByTimer = new Dictionary();
            this.modelRegister = (Main.osgi.getService(IModelService) as IModelService);
        }
        public function setRemaining(clientObject:String, remaining:Number):void
        {
            var i:int;
            this.remainingTime[clientObject] = remaining;
            var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IItemEffectListener);
            if (listeners != null)
            {
                i = 0;
                while (i < listeners.length)
                {
                    (listeners[i] as IItemEffectListener).setTimeRemaining(clientObject, remaining);
                    i++;
                }
            }
        }
        public function effectStopped(clientObject:String):void
        {
            var i:int;
            this.remainingTime[clientObject] = null;
            var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IItemEffectListener);
            if (listeners != null)
            {
                i = 0;
                while (i < listeners.length)
                {
                    (listeners[i] as IItemEffectListener).effectStopped(clientObject);
                    i++;
                }
            }
        }
        public function getTimeRemaining(itemId:String):Number
        {
            var time:Number = this.remainingTime[itemId];
            return (time);
        }

    }
}
