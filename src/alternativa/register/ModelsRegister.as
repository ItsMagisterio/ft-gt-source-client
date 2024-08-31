package alternativa.register
{
    import alternativa.service.IModelService;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.object.ClientObject;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import alternativa.service.Logger;
    import alternativa.osgi.service.log.LogLevel;
    import __AS3__.vec.*;

    public class ModelsRegister implements IModelService
    {

        private var modelInstances:Dictionary;
        private var modelInstancesByInterface:Dictionary;
        private var modelInterfaces:Dictionary;
        private var modelByMethod:Dictionary;
        private var modelsParamsStruct:Dictionary;
        private var _modelsList:Vector.<IModel>;

        public function ModelsRegister()
        {
            this.modelInterfaces = new Dictionary();
            this.modelInstances = new Dictionary();
            this.modelByMethod = new Dictionary();
            this.modelInstancesByInterface = new Dictionary();
            this.modelsParamsStruct = new Dictionary();
            this._modelsList = new Vector.<IModel>();
        }
        public function register(modelId:String, methodId:String):void
        {
            this.modelByMethod[methodId] = modelId;
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "Метод %1 (модель %2) зарегистрирован", methodId, modelId);
        }
        public function registerModelsParamsStruct(modelId:String, paramsStruct:Class):void
        {
            this.modelsParamsStruct[modelId] = paramsStruct;
        }
        public function unregisterModelsParamsStruct(modelId:String):void
        {
            this.modelsParamsStruct[modelId] = null;
        }
        public function getModelsParamsStruct(modelId:String):Class
        {
            return (this.modelsParamsStruct[modelId]);
        }
        public function add(modelInstance:IModel):void
        {
            var key:Class;
            var record:Vector.<IModel>;
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "add model %1", modelInstance);
            this._modelsList.push(modelInstance);
            var modelId:String = modelInstance.id;
            this.modelInstances[modelId] = modelInstance;
            var interfaces:Vector.<Class> = modelInstance.interfaces;
            this.modelInterfaces[modelId] = interfaces;
            var i:int;
            while (i < interfaces.length)
            {
                key = interfaces[i];
                record = this.modelInstancesByInterface[key];
                if (record == null)
                {
                    this.modelInstancesByInterface[key] = (record = new Vector.<IModel>());
                }
                record.push(modelInstance);
                i++;
            }
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "Реализация модели id: %1 %2 добавлена в реестр", modelId, modelInstance);
        }
        public function remove(modelId:String):void
        {
            var methodId:* = undefined;
            var instance:IModel;
            var interfaces:Vector.<Class>;
            var i:int;
            var id:String;
            var key:Class;
            var modelsArray:Vector.<IModel>;
            var index:int;
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "remove model id: %1", modelId);
            this._modelsList.splice(this._modelsList.indexOf(this.modelInstances[modelId]), 1);
            for (methodId in this.modelByMethod)
            {
                id = this.modelByMethod[methodId];
                if (id == modelId)
                {
                    delete this.modelByMethod[methodId];
                }
            }
            instance = IModel(this.modelInstances[modelId]);
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "   model instance: %1", instance);
            interfaces = (this.modelInterfaces[modelId] as Vector.<Class>);
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "   model interfaces: %1", interfaces);
            i = 0;
            while (i < interfaces.length)
            {
                key = interfaces[i];
                modelsArray = (this.modelInstancesByInterface[key] as Vector.<IModel>);
                Main.writeVarsToConsoleChannel("MODEL REGISTER", "   models for interface %1: %2", key, modelsArray);
                index = modelsArray.indexOf(instance);
                modelsArray.splice(index, 1);
                i++;
            }
            delete this.modelInterfaces[modelId];
            delete this.modelInstances[modelId];
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "Реализация модели id: %1 удалена из реестра", modelId);
        }
        public function invoke(clientObject:ClientObject, methodId:String, params:IDataInput, nullMap:NullMap):void
        {
            var modelId:String = String(this.modelByMethod[methodId]);
            var model:IModel = IModel(this.modelInstances[modelId]);
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "invoke");
            Main.writeVarsToConsoleChannel("MODEL REGISTER", ("   methodId: " + methodId), 0xFF);
            Main.writeVarsToConsoleChannel("MODEL REGISTER", ("   clientObjectId: " + clientObject.id), 0xFF);
            Main.writeVarsToConsoleChannel("MODEL REGISTER", ("   invoke modelId: " + modelId), 0xFF);
            Main.writeVarsToConsoleChannel("MODEL REGISTER", ("   invoke model: " + model), 0xFF);
            if (model != null)
            {
                model.invoke(clientObject, methodId, Main.codecFactory, params, nullMap);
            }
            else
            {
                Main.writeVarsToConsoleChannel("MODEL REGISTER", "   method invoke failed. MODEL NOT FOUND");
            }
        }
        public function getModel(id:String):IModel
        {
            return (this.modelInstances[id]);
        }
        public function getModelsByInterface(modelInterface:Class):Vector.<IModel>
        {
            Main.writeVarsToConsoleChannel("MODEL REGISTER", "getModelsByInterface %1: %2", modelInterface, this.modelInstancesByInterface[modelInterface]);
            return (this.modelInstancesByInterface[modelInterface]);
        }
        public function getModelForObject(object:ClientObject, modelInterface:Class):IModel
        {
            var msg:String;
            var model:IModel;
            var interfaces:Vector.<Class>;
            var n:int;
            if (object == null)
            {
                msg = ("Object is null. Model interface = " + modelInterface);
                Logger.log(LogLevel.LOG_ERROR, ("ModelRegister::getModelForObject " + msg));
            }
            if (modelInterface == null)
            {
                msg = ("Model interface is null. Object id = " + object.id);
                Logger.log(LogLevel.LOG_ERROR, ("ModelRegister::getModelForObject " + msg));
                throw (new ArgumentError(msg));
            }
            var modelIds:Vector.<String> = object.getModels();
            var i:int = (modelIds.length - 1);
            while (i >= 0)
            {
                interfaces = (this.modelInterfaces[modelIds[i]] as Vector.<Class>);
                if (interfaces == null)
                {
                    throw (new Error(((("No interfaces found. Object id=" + object.id) + ", model id=") + modelIds[i])));
                }
                n = (interfaces.length - 1);
                while (n >= 0)
                {
                    if (interfaces[n] == modelInterface)
                    {
                        if (model == null)
                        {
                            model = this.getModel(modelIds[i]);
                            break;
                        }
                        throw (new Error("MODEL REGISTER getModelForObject: Найдено несколько моделей с указанным интерфейсом."));
                    }
                    n--;
                }
                i--;
            }
            return (model);
        }
        public function getModelsForObject(object:ClientObject, modelInterface:Class):Vector.<IModel>
        {
            var interfaces:Vector.<Class>;
            var n:int;
            var result:Vector.<IModel> = new Vector.<IModel>();
            var modelIds:Vector.<String> = object.getModels();
            var i:int = (modelIds.length - 1);
            while (i >= 0)
            {
                interfaces = (this.modelInterfaces[modelIds[i]] as Vector.<Class>);
                if (interfaces == null)
                {
                    throw (new Error(((("No interfaces found. Object id=" + object.id) + ", model id=") + modelIds[i])));
                }
                n = (interfaces.length - 1);
                while (n >= 0)
                {
                    if (interfaces[n] == modelInterface)
                    {
                        result.push(this.getModel(modelIds[i]));
                        break;
                    }
                    n--;
                }
                i--;
            }
            return (result);
        }
        public function getInterfacesForModel(id:String):Vector.<Class>
        {
            return (this.modelInterfaces[id]);
        }
        public function get modelsList():Vector.<IModel>
        {
            return (this._modelsList);
        }

    }
}
