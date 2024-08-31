package projects.tanks.client.chat.models.news.showing
{
   import alternativa.types.Long;

   public class NewsItemData
   {

      private var _dateInSeconds:String;

      private var _description:String;

      private var _endDate:int;

      private var _header:String;

      private var _id:int;

      private var _imageUrl:String;

      public function NewsItemData(param1:String = null, param2:String = null, param3:int = 0, param4:String = null, param5:int = 0, param6:String = null)
      {
         super();
         this._dateInSeconds = param1;
         this._description = param2;
         this._endDate = param3;
         this._header = param4;
         this._id = param5;
         this._imageUrl = param6;
      }

      public function get dateInSeconds():String
      {
         return this._dateInSeconds;
      }

      public function set dateInSeconds(param1:String):void
      {
         this._dateInSeconds = param1;
      }

      public function get description():String
      {
         return this._description;
      }

      public function set description(param1:String):void
      {
         this._description = param1;
      }

      public function get endDate():int
      {
         return this._endDate;
      }

      public function set endDate(param1:int):void
      {
         this._endDate = param1;
      }

      public function get header():String
      {
         return this._header;
      }

      public function set header(param1:String):void
      {
         this._header = param1;
      }

      public function get id():int
      {
         return this._id;
      }

      public function set id(param1:int):void
      {
         this._id = param1;
      }

      public function get imageUrl():String
      {
         return this._imageUrl;
      }

      public function set imageUrl(param1:String):void
      {
         this._imageUrl = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "NewsItemData [";
         _loc1_ += "dateInSeconds = " + this.dateInSeconds + " ";
         _loc1_ += "description = " + this.description + " ";
         _loc1_ += "endDate = " + this.endDate + " ";
         _loc1_ += "header = " + this.header + " ";
         _loc1_ += "id = " + this.id + " ";
         _loc1_ += "imageUrl = " + this.imageUrl + " ";
         return _loc1_ + "]";
      }
   }
}
