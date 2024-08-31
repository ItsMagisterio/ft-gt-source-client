package platform.loading.codecs
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import flash.utils.IDataInput;
   import platform.client.core.general.spaces.loading.dispatcher.types.ObjectsData;
   import platform.client.core.general.spaces.loading.modelconstructors.ModelData;
   import platform.client.fp10.core.registry.GameTypeRegistry;
   import platform.client.fp10.core.registry.SpaceRegistry;
   import platform.client.fp10.core.type.IGameClass;
   import platform.client.fp10.core.type.IGameObject;
   import platform.client.fp10.core.type.ISpace;

   public class ObjectsDataCodec implements ICodec
   {

      private var modelDataCodec:platform.loading.codecs.ModelDataCodec;

      private var longCodec:ICodec;

      private var gameTypeRegistry:GameTypeRegistry;

      private var spaceRegistry:SpaceRegistry;

      public function ObjectsDataCodec()
      {
         this.modelDataCodec = new platform.loading.codecs.ModelDataCodec();
         super();
      }

      public function init(param1:IProtocol):void
      {
         this.modelDataCodec.init(param1);
         this.longCodec = param1.getCodec(new TypeCodecInfo(Long, false));
         this.gameTypeRegistry = OSGi.getInstance().getService(GameTypeRegistry);
         this.spaceRegistry = OSGi.getInstance().getService(SpaceRegistry);
      }

      public function encode(param1:ProtocolBuffer, param2:Object):void
      {
         throw new Error("unsupported");
      }

      public function decode(param1:ProtocolBuffer):Object
      {
         var _loc2_:ObjectsData = new ObjectsData();
         _loc2_.objects = this.decodeObjects(param1);
         _loc2_.modelsData = this.decodeModelsData(param1);
         return _loc2_;
      }

      private function decodeObjects(param1:ProtocolBuffer):Vector.<IGameObject>
      {
         var _loc2_:IDataInput = param1.reader;
         var _loc3_:int = int(_loc2_.readInt());
         var _loc4_:Vector.<IGameObject> = new Vector.<IGameObject>(_loc3_);
         var _loc5_:int = 0;
         while (_loc5_ < _loc3_)
         {
            _loc4_[_loc5_] = this.readObject(param1);
            _loc5_++;
         }
         return _loc4_;
      }

      private function readObject(param1:ProtocolBuffer):IGameObject
      {
         var _loc2_:Long = Long(this.longCodec.decode(param1));
         var _loc3_:Long = Long(this.longCodec.decode(param1));
         var _loc4_:ISpace = this.spaceRegistry.currentSpace;
         if (_loc4_.rootObject.id == _loc2_)
         {
            _loc4_.destroyObject(_loc2_);
         }
         var _loc5_:IGameClass = this.gameTypeRegistry.getClass(_loc3_);
         if (_loc5_ == null)
         {
            throw new Error("Class not found exception class=" + _loc3_ + ", object=" + _loc2_);
         }
         return _loc4_.createObject(_loc2_, _loc5_, "");
      }

      private function decodeModelsData(param1:ProtocolBuffer):Vector.<ModelData>
      {
         var _loc2_:int = int(param1.reader.readInt());
         var _loc3_:Vector.<ModelData> = new Vector.<ModelData>(_loc2_);
         var _loc4_:int = 0;
         while (_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = ModelData(this.modelDataCodec.decode(param1));
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
