package forms.itemscategory.shoteffects
{
   import controls.base.DefaultButtonBase;

   public class CloseBut extends DefaultButtonBase
   {

      private static const LABEL_MARGIN:int = 26;

      public function CloseBut()
      {
         super();
      }

      override public function set width(param1:Number):void
      {
         var _loc2_:int = Math.ceil(_label.textWidth) + LABEL_MARGIN;
         if (_loc2_ > param1)
         {
            super.width = _loc2_;
         }
         else
         {
            super.width = param1;
         }
      }

      override public function get width():Number
      {
         return _width;
      }
   }
}
