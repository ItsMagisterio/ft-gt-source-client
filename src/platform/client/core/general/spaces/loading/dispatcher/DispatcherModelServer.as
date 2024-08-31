package platform.client.core.general.spaces.loading.dispatcher
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.OptionalMap;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import flash.utils.ByteArray;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.network.command.SpaceCommand;
   import platform.client.fp10.core.type.IGameObject;
   import platform.client.fp10.core.type.ISpace;

   public class DispatcherModelServer
   {

      private var protocol:IProtocol;

      private var protocolBuffer:ProtocolBuffer;

      private var _dependeciesLoadedId:Long;

      private var _dependeciesLoaded_callbackIdCodec:ICodec;

      private var model:IModel;

      public function DispatcherModelServer(param1:IModel)
      {
         this._dependeciesLoadedId = Long.getLong(423004956, 1791645716);
         super();
         this.model = param1;
         var _loc2_:ByteArray = new ByteArray();
         this.protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.protocolBuffer = new ProtocolBuffer(_loc2_, _loc2_, new OptionalMap());
         this._dependeciesLoaded_callbackIdCodec = this.protocol.getCodec(new TypeCodecInfo(int, false));
      }

      public function dependeciesLoaded(param1:int):void
      {
         ByteArray(this.protocolBuffer.writer).position = 0;
         ByteArray(this.protocolBuffer.writer).length = 0;
         this._dependeciesLoaded_callbackIdCodec.encode(this.protocolBuffer, param1);
         ByteArray(this.protocolBuffer.writer).position = 0;
         if (Model.object == null)
         {
            throw new Error("Execute method without model context.");
         }
         var _loc2_:SpaceCommand = new SpaceCommand(Model.object.id, this._dependeciesLoadedId, this.protocolBuffer);
         var _loc3_:IGameObject = Model.object;
         var _loc4_:ISpace = _loc3_.space;
         _loc4_.commandSender.sendCommand(_loc2_);
         this.protocolBuffer.optionalMap.clear();
      }
   }
}
