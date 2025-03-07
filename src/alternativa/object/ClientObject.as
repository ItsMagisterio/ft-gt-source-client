﻿package alternativa.object
{
    import alternativa.register.ClientClass;
    import __AS3__.vec.Vector;
    import alternativa.types.Long;
    import flash.utils.Dictionary;
    import alternativa.network.ICommandHandler;
    import alternativa.register.ObjectRegister;
    import projects.tanks.client.panel.model.User;
    import alternativa.model.IModel;
    import __AS3__.vec.*;

    public class ClientObject
    {

        private var _name:String;
        private var _id:String;
        private var _clientClass:ClientClass;
        private var models:Vector.<IModel>;
        private var initParams:Dictionary;
        private var runtimeParams:Dictionary;
        private var sessionParams:Dictionary;
        private var _handler:ICommandHandler;
        private var _register:ObjectRegister;
        private var user:User;
        public var sessionId:String;

        public function ClientObject(id:String, clientClass:ClientClass, name:String, handler:ICommandHandler)
        {
            this._id = id;
            this._clientClass = clientClass;
            this._name = name;
            this._handler = handler;
            if (this.models != null)
            {
                this.models = this.models;
            }
            else
            {
                this.models = new Vector.<IModel>();
            }
            this.initParams = new Dictionary();
            this.runtimeParams = new Dictionary();
            this.sessionParams = new Dictionary();
        }
        public function addModel(model:IModel):void
        {
            this.models.push(model);
        }
        public function removeModel(model:IModel):void
        {
            var index:int = this.models.indexOf(model);
            this.models.splice(index, 1);
        }
        public function getParams(model:Class):Object
        {
            return (this.runtimeParams[model]);
        }
        public function putParams(model:Class, params:Object):void
        {
            this.runtimeParams[model] = params;
        }
        public function getSessionParams(param1:String):Object
        {
            return (this.sessionParams[param1]);
        }
        public function putSessionParams(param1:String, params:Object):void
        {
            this.sessionParams[param1] = params;
        }
        public function removeParams(model:Class):Object
        {
            var params:Object = this.runtimeParams[model];
            delete this.runtimeParams[model];
            return (params);
        }
        public function getInitParams(modelInstance:IModel):Object
        {
            return (this.initParams[modelInstance]);
        }
        public function putInitParams(modelInstance:IModel, params:Object):void
        {
            this.initParams[modelInstance] = params;
        }
        public function get id():String
        {
            return (this._id);
        }
        public function get name():String
        {
            return (this._name);
        }
        public function get clientClass():ClientClass
        {
            return (this._clientClass);
        }
        public function get handler():ICommandHandler
        {
            return (this._handler);
        }
        public function getModels():Vector.<String>
        {
            return (this._clientClass.models);
        }
        public function get register():ObjectRegister
        {
            return (this._register);
        }
        public function set register(value:ObjectRegister):void
        {
            this._register = value;
        }

    }
}
