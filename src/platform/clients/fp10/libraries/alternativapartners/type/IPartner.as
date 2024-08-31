package platform.clients.fp10.libraries.alternativapartners.type
{
   [ModelInterface]
   public interface IPartner
   {

      function getLoginParameters(param1:IParametersListener):void;

      function paymentAction():void;
   }
}
