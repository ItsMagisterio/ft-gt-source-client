package alternativa.tanks.models.effectsvisualization
{
    import projects.tanks.client.battlefield.gui.models.effectsvisualization.EffectsVisualizationModelBase;
    import projects.tanks.client.battlefield.gui.models.effectsvisualization.IEffectsVisualizationModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.model.IModel;
    import alternativa.tanks.models.tank.TankModel;
    import __AS3__.vec.Vector;
    import projects.tanks.client.battlefield.gui.models.effectsvisualization.BattleEffect;
    import alternativa.init.Main;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.object.ClientObject;
    import flash.utils.getTimer;
    import alternativa.protocol.factory.ICodecFactory;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import __AS3__.vec.*;

    public class EffectsVisualizationModel extends EffectsVisualizationModelBase implements IEffectsVisualizationModelBase, IEffectsVisualizationModel, IObjectLoadListener, IModel
    {

        private var tankInterface:TankModel;
        private var initialEffects:Vector.<BattleEffect>;

        public function EffectsVisualizationModel()
        {
            _interfaces.push(IModel, IEffectsVisualizationModel, IObjectLoadListener);
            Main.osgi.registerService(IEffectsVisualizationModel, this);
        }
        public function initObject(clientObject:ClientObject, effects:Array):void
        {
            var modelService:IModelService;
            if (effects == null)
            {
                this.initialEffects = null;
            }
            else
            {
                this.initialEffects = Vector.<BattleEffect>(effects);
            }
            if (this.tankInterface == null)
            {
                modelService = IModelService(Main.osgi.getService(IModelService));
                this.tankInterface = TankModel(Main.osgi.getService(ITank));
            }
        }
        public function effectActivated(clientObject:ClientObject, userID:String, itemIndex:int, duration:int):void
        {
            var userObject:ClientObject = clientObject;
            if (userObject != null)
            {
                this.tankInterface.effectStarted(userObject, itemIndex, duration);
            }
        }
        public function effectStopped(clientObject:ClientObject, userID:String, itemIndex:int):void
        {
            var len:uint;
            var i:int;
            var effect:BattleEffect;
            if (this.initialEffects != null)
            {
                len = this.initialEffects.length;
                i = 0;
                while (i < len)
                {
                    effect = this.initialEffects[i];
                    if (((effect.userID == userID) && (effect.itemIndex == itemIndex)))
                    {
                        this.initialEffects[i] = this.initialEffects[-- len];
                        this.initialEffects.length = len;
                        return;
                    }
                    i++;
                }
            }
            var userObject:ClientObject = clientObject;
            if (userObject != null)
            {
                this.tankInterface.effectStopped(userObject, itemIndex);
            }
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
            this.initialEffects = null;
        }
        public function getInitialEffects(userId:String):Vector.<ClientBattleEffect>
        {
            var result:Vector.<ClientBattleEffect>;
            var effect:BattleEffect;
            if (this.initialEffects == null)
            {
                return (null);
            }
            var now:int = getTimer();
            var i:int;
            while (i < this.initialEffects.length)
            {
                effect = this.initialEffects[i];
                if (effect.userID == userId)
                {
                    if (result == null)
                    {
                        result = new Vector.<ClientBattleEffect>();
                    }
                    result.push(new ClientBattleEffect(now, effect.userID, effect.itemIndex, effect.durationTime));
                    this.initialEffects.splice(i, 1);
                    i--;
                }
                i++;
            }
            if (this.initialEffects.length == 0)
            {
                this.initialEffects = null;
            }
            return (result);
        }
        public function _initObject(clientObject:ClientObject, params:Object):void
        {
        }
        public function invoke(clientObject:ClientObject, methodId:String, codecFactory:ICodecFactory, dataInput:IDataInput, nullMap:NullMap):void
        {
        }
        public function get id():String
        {
            return ("");
        }
        public function get interfaces():Vector.<Class>
        {
            return (_interfaces);
        }

    }
}
