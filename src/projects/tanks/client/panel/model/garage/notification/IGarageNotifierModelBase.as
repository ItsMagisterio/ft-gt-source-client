package projects.tanks.client.panel.model.garage.notification
{
   import projects.tanks.client.commons.types.ItemViewCategoryEnum;

   public interface IGarageNotifierModelBase
   {

      function notifyDiscountsInGarage(param1:Vector.<ItemViewCategoryEnum>):void;
   }
}
