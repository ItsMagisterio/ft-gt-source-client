package platform.client.core.general.pushnotification.osgi
{
   import _codec.platform.client.core.general.pushnotification.api.CodecNotificationClientPlatform;
   import _codec.platform.client.core.general.pushnotification.api.VectorCodecNotificationClientPlatformLevel1;
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.codec.OptionalCodecDecorator;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.EnumCodecInfo;
   import platform.client.core.general.pushnotification.api.NotificationClientPlatform;

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
         _loc3_ = new CodecNotificationClientPlatform();
         _loc2_.registerCodec(new EnumCodecInfo(NotificationClientPlatform, false), _loc3_);
         _loc2_.registerCodec(new EnumCodecInfo(NotificationClientPlatform, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecNotificationClientPlatformLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(NotificationClientPlatform, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(NotificationClientPlatform, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecNotificationClientPlatformLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(NotificationClientPlatform, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(NotificationClientPlatform, true), true, 1), new OptionalCodecDecorator(_loc3_));
      }

      public function stop(param1:OSGi):void
      {
      }
   }
}
