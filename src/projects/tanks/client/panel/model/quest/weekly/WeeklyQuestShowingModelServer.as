package projects.tanks.client.panel.model.quest.weekly
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

   public class WeeklyQuestShowingModelServer
   {

      private var protocol:IProtocol;

      private var protocolBuffer:ProtocolBuffer;

      private var _givePrizeId:Long;

      private var _givePrize_questIdCodec:ICodec;

      private var _openWindowId:Long;

      private var model:IModel;

      public function WeeklyQuestShowingModelServer(param1:IModel)
      {
         this._givePrizeId = Long.getLong(1969431742, 1254797569);
         this._openWindowId = Long.getLong(922791336, 1556591844);
         super();
         this.model = param1;
         var _loc2_:ByteArray = new ByteArray();
         this.protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.protocolBuffer = new ProtocolBuffer(_loc2_, _loc2_, new OptionalMap());
         this._givePrize_questIdCodec = this.protocol.getCodec(new TypeCodecInfo(Long, false));
      }

      public function givePrize(param1:Long):void
      {
         ByteArray(this.protocolBuffer.writer).position = 0;
         ByteArray(this.protocolBuffer.writer).length = 0;
         this._givePrize_questIdCodec.encode(this.protocolBuffer, param1);
         ByteArray(this.protocolBuffer.writer).position = 0;
         if (Model.object == null)
         {
            throw new Error("Execute method without model context.");
         }
         var _loc2_:SpaceCommand = new SpaceCommand(Model.object.id, this._givePrizeId, this.protocolBuffer);
         var _loc3_:IGameObject = Model.object;
         var _loc4_:ISpace = _loc3_.space;
         _loc4_.commandSender.sendCommand(_loc2_);
         this.protocolBuffer.optionalMap.clear();
      }

      public function openWindow():void
      {
         ByteArray(this.protocolBuffer.writer).position = 0;
         ByteArray(this.protocolBuffer.writer).length = 0;
         ByteArray(this.protocolBuffer.writer).position = 0;
         if (Model.object == null)
         {
            throw new Error("Execute method without model context.");
         }
         var _loc1_:SpaceCommand = new SpaceCommand(Model.object.id, this._openWindowId, this.protocolBuffer);
         var _loc2_:IGameObject = Model.object;
         var _loc3_:ISpace = _loc2_.space;
         _loc3_.commandSender.sendCommand(_loc1_);
         this.protocolBuffer.optionalMap.clear();
      }
   }
}
