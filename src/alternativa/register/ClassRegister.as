package alternativa.register
{
    import alternativa.service.IClassService;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import alternativa.init.Main;
    import alternativa.types.Long;
    import __AS3__.vec.*;

    public class ClassRegister implements IClassService
    {

        private var _classes:Dictionary;
        private var _classList:Array;

        public function ClassRegister()
        {
            this._classList = new Array();
            this._classes = new Dictionary();
        }
        public function createClass(id:String, parent:ClientClass, name:String, modelsToAdd:Array, modelsToRemove:Array):ClientClass
        {
            var parentModels:Vector.<String>;
            var i:int;
            var parentParams:Dictionary;
            var modelId:* = undefined;
            var models:Vector.<String> = new Vector.<String>();
            if (parent != null)
            {
                parentModels = parent.models;
                i = 0;
                while (i < parentModels.length)
                {
                    if (modelsToRemove != null)
                    {
                        if (modelsToRemove.indexOf(parentModels[i]) == -1)
                        {
                            models.push(parentModels[i]);
                        }
                    }
                    else
                    {
                        models.push(parentModels[i]);
                    }
                    i++;
                }
            }
            if (modelsToAdd != null)
            {
                i = 0;
                while (i < modelsToAdd.length)
                {
                    models.push(modelsToAdd[i]);
                    i++;
                }
            }
            models.sort(this.compareModelsId);
            var newClass:ClientClass = new ClientClass(id, parent, name, models);
            if (parent != null)
            {
                parent.addChild(newClass);
                parentParams = parent.modelsParams;
                for (modelId in parentParams)
                {
                    newClass.setModelParams(modelId, parentParams[modelId]);
                }
            }
            this._classes[id] = newClass;
            this._classList.push(newClass);
            Main.writeToConsole((((("ClassRegister ClientClass id:" + id) + " name:") + name) + " зарегистрирован"));
            return (newClass);
        }
        private function compareModelsId(id1:Long, id2:Long):int
        {
            var result:int = (id1.high - id2.high);
            if (result == 0)
            {
                result = (id1.low - id2.low);
            }
            return (result);
        }
        public function destroyClass(id:String):void
        {
            this._classList.splice(this._classList.indexOf(this._classes[id]), 1);
            this._classes[id] = null;
        }
        public function getClass(id:String):ClientClass
        {
            return (this._classes[id]);
        }
        public function get classes():Dictionary
        {
            return (this._classes);
        }
        public function get classList():Array
        {
            return (this._classList);
        }

    }
}
