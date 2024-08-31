package platform.client.core.general.socialnetwork.osgi
{
   import _codec.map.String__String;
   import _codec.platform.client.core.general.socialnetwork.models.socialnetworkparameters.CodecSocialNetworkParametersCC;
   import _codec.platform.client.core.general.socialnetwork.models.socialnetworkparameters.VectorCodecSocialNetworkParametersCCLevel1;
   import _codec.platform.client.core.general.socialnetwork.types.CodecGender;
   import _codec.platform.client.core.general.socialnetwork.types.CodecLoginParameters;
   import _codec.platform.client.core.general.socialnetwork.types.VectorCodecGenderLevel1;
   import _codec.platform.client.core.general.socialnetwork.types.VectorCodecLoginParametersLevel1;
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.codec.OptionalCodecDecorator;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.EnumCodecInfo;
   import alternativa.protocol.info.MapCodecInfo;
   import alternativa.protocol.info.TypeCodecInfo;
   import platform.client.core.general.socialnetwork.models.socialnetworkparameters.SocialNetworkParametersCC;
   import platform.client.core.general.socialnetwork.types.Gender;
   import platform.client.core.general.socialnetwork.types.LoginParameters;

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
         _loc3_ = new CodecSocialNetworkParametersCC();
         _loc2_.registerCodec(new TypeCodecInfo(SocialNetworkParametersCC, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(SocialNetworkParametersCC, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecGender();
         _loc2_.registerCodec(new EnumCodecInfo(Gender, false), _loc3_);
         _loc2_.registerCodec(new EnumCodecInfo(Gender, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new CodecLoginParameters();
         _loc2_.registerCodec(new TypeCodecInfo(LoginParameters, false), _loc3_);
         _loc2_.registerCodec(new TypeCodecInfo(LoginParameters, true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new String__String(false, false);
         _loc2_.registerCodec(new MapCodecInfo(new TypeCodecInfo(String, false), new TypeCodecInfo(String, false), false), _loc3_);
         _loc2_.registerCodec(new MapCodecInfo(new TypeCodecInfo(String, false), new TypeCodecInfo(String, false), true), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecSocialNetworkParametersCCLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(SocialNetworkParametersCC, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(SocialNetworkParametersCC, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecSocialNetworkParametersCCLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(SocialNetworkParametersCC, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(SocialNetworkParametersCC, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecGenderLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(Gender, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(Gender, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecGenderLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(Gender, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new EnumCodecInfo(Gender, true), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecLoginParametersLevel1(false);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LoginParameters, false), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LoginParameters, false), true, 1), new OptionalCodecDecorator(_loc3_));
         _loc3_ = new VectorCodecLoginParametersLevel1(true);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LoginParameters, true), false, 1), _loc3_);
         _loc2_.registerCodec(new CollectionCodecInfo(new TypeCodecInfo(LoginParameters, true), true, 1), new OptionalCodecDecorator(_loc3_));
      }

      public function stop(param1:OSGi):void
      {
      }
   }
}
