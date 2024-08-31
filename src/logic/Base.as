// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.Base

package logic
{
    import alternativa.model.IModel;
    import __AS3__.vec.Vector;
    import alternativa.object.ClientObject;
    import alternativa.protocol.factory.ICodecFactory;
    import flash.utils.IDataInput;
    import alternativa.protocol.codec.NullMap;
    import __AS3__.vec.*;

    public class Base implements IModel
    {

        public var _interfaces:Vector.<Class>;

        public function Base()
        {
            this._interfaces = new Vector.<Class>();
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
            return (this._interfaces);
        }

    }
} // package scpacker