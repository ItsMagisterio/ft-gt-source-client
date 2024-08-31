package platform.loading.codecs
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import alternativa.types.Short;
   import flash.utils.IDataInput;
   import platform.client.core.general.spaces.loading.dispatcher.types.ObjectsDependencies;
   import platform.client.fp10.core.registry.GameTypeRegistry;
   import platform.client.fp10.core.registry.ResourceRegistry;
   import platform.client.fp10.core.resource.Resource;
   import platform.client.fp10.core.resource.ResourceInfo;

   public class ObjectsDependenciesCodec implements ICodec
   {

      private var gameTypeRegistry:GameTypeRegistry;

      private var resourceRegistry:ResourceRegistry;

      private var longCodec:ICodec;

      private var shortCodec:ICodec;

      private var booleanCodec:ICodec;

      public function ObjectsDependenciesCodec()
      {
         super();
      }

      public function init(param1:IProtocol):void
      {
         var _loc2_:OSGi = OSGi.getInstance();
         this.gameTypeRegistry = _loc2_.getService(GameTypeRegistry);
         this.resourceRegistry = _loc2_.getService(ResourceRegistry);
         this.longCodec = param1.getCodec(new TypeCodecInfo(Long, false));
         this.shortCodec = param1.getCodec(new TypeCodecInfo(Short, false));
         this.booleanCodec = param1.getCodec(new TypeCodecInfo(Boolean, false));
      }

      public function encode(param1:ProtocolBuffer, param2:Object):void
      {
         throw new Error("unsupported");
      }

      public function decode(param1:ProtocolBuffer):Object
      {
         var _loc2_:ObjectsDependencies = new ObjectsDependencies();
         _loc2_.callbackId = param1.reader.readInt();
         this.readGameClasses(param1);
         _loc2_.resources = this.readResources(param1);
         return _loc2_;
      }

      private function readGameClasses(param1:ProtocolBuffer):void
      {
         var _loc2_:int = int(param1.reader.readInt());
         var _loc3_:int = 0;
         while (_loc3_ < _loc2_)
         {
            this.decodeAndRegisterGameClass(param1);
            _loc3_++;
         }
      }

      private function decodeAndRegisterGameClass(param1:ProtocolBuffer):void
      {
         var _loc2_:Long = Long(this.longCodec.decode(param1));
         var _loc3_:int = int(param1.reader.readInt());
         var _loc4_:Vector.<Long> = new Vector.<Long>(_loc3_);
         var _loc5_:int = 0;
         while (_loc5_ < _loc3_)
         {
            _loc4_[_loc5_] = Long(this.longCodec.decode(param1));
            _loc5_++;
         }
         this.gameTypeRegistry.createClass(_loc2_, _loc4_);
      }

      private function readResources(param1:ProtocolBuffer):Vector.<Resource>
      {
         var _loc6_:Resource = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Long = null;
         var _loc11_:Resource = null;
         var _loc2_:IDataInput = param1.reader;
         var _loc3_:int = int(_loc2_.readInt());
         var _loc4_:Vector.<Resource> = new Vector.<Resource>();
         var _loc5_:int = 0;
         while (_loc5_ < _loc3_)
         {
            _loc6_ = this.getResource(this.readResourceInfo(param1));
            _loc7_ = !_loc6_.isLazy && _loc6_.status == null;
            if (_loc7_)
            {
               _loc4_.push(_loc6_);
            }
            _loc8_ = int(_loc2_.readByte());
            _loc9_ = 0;
            while (_loc9_ < _loc8_)
            {
               _loc10_ = Long(this.longCodec.decode(param1));
               if (!(_loc10_.low == 10002058 || _loc10_.low == 10002059))
               {
                  if (_loc7_)
                  {
                     _loc11_ = this.resourceRegistry.getResource(_loc10_);
                     if (!_loc11_.isLoaded)
                     {
                        _loc6_.addDependence(_loc11_);
                     }
                  }
               }
               _loc9_++;
            }
            _loc5_++;
         }
         return _loc4_;
      }

      private function getResource(param1:ResourceInfo):Resource
      {
         var _loc2_:Long = param1.id;
         if (this.resourceRegistry.isRegistered(_loc2_))
         {
            return this.resourceRegistry.getResource(_loc2_);
         }
         if (!this.resourceRegistry.isTypeClassRegistered(param1.type))
         {
            throw new Error("Unknown resource type");
         }
         var _loc3_:Class = this.resourceRegistry.getResourceClass(param1.type);
         var _loc4_:Resource = Resource(new _loc3_(param1));
         this.resourceRegistry.registerResource(_loc4_);
         return _loc4_;
      }

      private function readResourceInfo(param1:ProtocolBuffer):ResourceInfo
      {
         var _loc2_:Long = Long(this.longCodec.decode(param1));
         var _loc3_:int = int(this.shortCodec.decode(param1));
         var _loc4_:Long = Long(this.longCodec.decode(param1));
         var _loc5_:Boolean = Boolean(this.booleanCodec.decode(param1));
         return new ResourceInfo(_loc3_, _loc2_, _loc4_, _loc5_);
      }
   }
}
