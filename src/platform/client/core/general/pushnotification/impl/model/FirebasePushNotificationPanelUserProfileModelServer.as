package platform.client.core.general.pushnotification.impl.model
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.OptionalMap;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.EnumCodecInfo;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import flash.utils.ByteArray;
   import platform.client.core.general.pushnotification.api.NotificationClientPlatform;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.network.command.SpaceCommand;
   import platform.client.fp10.core.type.IGameObject;
   import platform.client.fp10.core.type.ISpace;

   public class FirebasePushNotificationPanelUserProfileModelServer
   {

      private var protocol:IProtocol;

      private var protocolBuffer:ProtocolBuffer;

      private var _storeTokenId:Long;

      private var _storeToken_platformCodec:ICodec;

      private var _storeToken_tokenCodec:ICodec;

      private var model:IModel;

      public function FirebasePushNotificationPanelUserProfileModelServer(param1:IModel)
      {
         this._storeTokenId = Long.getLong(1272774525, -863530729);
         super();
         this.model = param1;
         var _loc2_:ByteArray = new ByteArray();
         this.protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.protocolBuffer = new ProtocolBuffer(_loc2_, _loc2_, new OptionalMap());
         this._storeToken_platformCodec = this.protocol.getCodec(new EnumCodecInfo(NotificationClientPlatform, false));
         this._storeToken_tokenCodec = this.protocol.getCodec(new TypeCodecInfo(String, false));
      }

      public function storeToken(param1:NotificationClientPlatform, param2:String):void
      {
         ByteArray(this.protocolBuffer.writer).position = 0;
         ByteArray(this.protocolBuffer.writer).length = 0;
         this._storeToken_platformCodec.encode(this.protocolBuffer, param1);
         this._storeToken_tokenCodec.encode(this.protocolBuffer, param2);
         ByteArray(this.protocolBuffer.writer).position = 0;
         if (Model.object == null)
         {
            throw new Error("Execute method without model context.");
         }
         var _loc3_:SpaceCommand = new SpaceCommand(Model.object.id, this._storeTokenId, this.protocolBuffer);
         var _loc4_:IGameObject = Model.object;
         var _loc5_:ISpace = _loc4_.space;
         _loc5_.commandSender.sendCommand(_loc3_);
         this.protocolBuffer.optionalMap.clear();
      }
   }
}
