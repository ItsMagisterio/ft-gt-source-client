package platform.client.models.commons.osgi
{
   import _codec.platform.client.models.commons.description.CodecDescriptionModelCC;
   import _codec.platform.client.models.commons.description.VectorCodecDescriptionModelCCLevel1;
   import _codec.platform.client.models.commons.periodtime.CodecTimePeriodModelCC;
   import _codec.platform.client.models.commons.periodtime.VectorCodecTimePeriodModelCCLevel1;
   import _codec.platform.client.models.commons.types.CodecTimestamp;
   import _codec.platform.client.models.commons.types.CodecValidationStatus;
   import _codec.platform.client.models.commons.types.VectorCodecTimestampLevel1;
   import _codec.platform.client.models.commons.types.VectorCodecValidationStatusLevel1;
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.codec.OptionalCodecDecorator;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.EnumCodecInfo;
   import alternativa.protocol.info.TypeCodecInfo;
   import platform.client.models.commons.description.DescriptionModelCC;
   import platform.client.models.commons.periodtime.TimePeriodModelCC;
   import platform.client.models.commons.types.Timestamp;
   import platform.client.models.commons.types.ValidationStatus;

   public class Activator implements IBundleActivator
   {

      public static var osgi:OSGi;

      public function Activator()
      {
         super();
      }

      public function start(param1:OSGi):void
      {
         var _loc3_:ICodec = null;
         osgi = param1;
         var _loc2_:IProtocol = IProtocol(osgi.getService(IProtocol));
         _loc3_ = new CodecDescriptionModelCC();
         _loc2_.registerCodec(new TypeCodecInfo(DescriptionModelCC, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(DescriptionModelCC, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecTimePeriodModelCC();
         _loc2_.registerCodec(new TypeCodecInfo(TimePeriodModelCC, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(TimePeriodModelCC, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecTimestamp();
         _loc2_.registerCodec(new TypeCodecInfo(Timestamp, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(Timestamp, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecValidationStatus();
         _loc2_.registerCodec(new EnumCodecInfo(ValidationStatus, false), _loc3_);
         _loc2_.registerCodec(new EnumCodecInfo(ValidationStatus, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecDescriptionModelCCLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(DescriptionModelCC, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(DescriptionModelCC, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecDescriptionModelCCLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(DescriptionModelCC, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(DescriptionModelCC, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecTimePeriodModelCCLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(TimePeriodModelCC, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(TimePeriodModelCC, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecTimePeriodModelCCLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(TimePeriodModelCC, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(TimePeriodModelCC, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecTimestampLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(Timestamp, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(Timestamp, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecTimestampLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(Timestamp, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(Timestamp, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecValidationStatusLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ValidationStatus, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ValidationStatus, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecValidationStatusLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ValidationStatus, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(ValidationStatus, true), true, 1), new OptionalCodecDecorator(_loc3_));
      }

      public function stop(param1:OSGi):void
      {
      }
   }
}
