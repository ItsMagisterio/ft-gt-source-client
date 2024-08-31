package alternativa.register
{
    import flash.utils.Dictionary;
    import alternativa.network.ICommandHandler;
    import alternativa.service.Logger;
    import alternativa.object.ClientObject;
    import alternativa.osgi.service.log.LogLevel;
    import alternativa.init.Main;
    import __AS3__.vec.Vector;
    import alternativa.model.IObjectLoadListener;
    import alternativa.osgi.service.log.ILogService;
    import alternativa.service.IModelService;

    public class ObjectRegister
    {

        private static const CHANNEL:String = "OBJREG";
        private static var counter:int;

        private var objects:Dictionary;
        private var _objectsList:Array;
        private var commandHandler:ICommandHandler;
        public var id:int;
        public var space:SpaceInfo;

        public function ObjectRegister(commandHandler:ICommandHandler)
        {
            this.commandHandler = commandHandler;
            this.objects = new Dictionary();
            this._objectsList = new Array();
            this.id = counter++;
        }
        public function createObject(objectId:String, clientClass:ClientClass, name:String):ClientObject
        {
            var logger:Logger;
            var object:ClientObject;
            if (this.objects[objectId] != null)
            {
                Logger.log(LogLevel.LOG_ERROR, (("FATAL ERROR: ПОПЫТКА СОЗДАНИЯ 2-ГО ДИСПЕТЧЕРА!!! (spaceId: " + this.space.id) + ")"));
            }
            else
            {
                if (this.objects[objectId] != null)
                {
                    Logger.log(LogLevel.LOG_ERROR, (((("FATAL ERROR: Повторная загрузка объекта (objectId: " + objectId) + ", name: ") + name) + ")"));
                }
                else
                {
                    object = new ClientObject(objectId, clientClass, name, this.commandHandler);
                    this.registerObject(object);
                    Main.writeVarsToConsoleChannel(CHANNEL, "Object ADDED: space id=%1, register id=%2, object id=%3", ((this.space == null) ? "none" : this.space.id), this.id, objectId);
                }
            }
            return (this.objects[objectId]);
        }
        public function destroyObject(objectId:String):void
        {
            var models:Vector.<String>;
            var i:int;
            var m:IObjectLoadListener;
            var clientObject:ClientObject = this.objects[objectId];
            if (clientObject == null)
            {
                (Main.osgi.getService(ILogService) as ILogService).log(LogLevel.LOG_ERROR, (("[ObjectRegister::destroyObject] ERROR: clientObject == null! (id: " + objectId) + ")"));
            }
            else
            {
                Main.writeVarsToConsoleChannel(CHANNEL, "Destroying object: space id=%1, register id=%2, object id=%3", ((this.space == null) ? "none" : this.space.id), this.id, objectId);
                models = clientObject.getModels();
                if (models != null)
                {
                    i = 0;
                    while (i < models.length)
                    {
                        m = (IModelService(Main.osgi.getService(IModelService)).getModel(models[i]) as IObjectLoadListener);
                        if (m != null)
                        {
                            m.objectUnloaded(clientObject);
                        }
                        i++;
                    }
                }
                this._objectsList.splice(this._objectsList.indexOf(this.objects[objectId]), 1);
                delete this.objects[objectId];
                Main.writeVarsToConsoleChannel(CHANNEL, "Object DESTROYED");
            }
        }
        private function registerObject(object:ClientObject):void
        {
            this.objects[object.id] = object;
            this._objectsList.push(object);
            object.register = this;
        }
        public function getObject(id:String):ClientObject
        {
            return (this.objects[id]);
        }
        public function getObjects():Dictionary
        {
            return (this.objects);
        }
        public function get objectsList():Array
        {
            return (this._objectsList);
        }

    }
}
