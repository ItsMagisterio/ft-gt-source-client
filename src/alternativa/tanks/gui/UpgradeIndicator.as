package alternativa.tanks.gui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class UpgradeIndicator extends Sprite
   {
      
      private static const bitmapUpgradeIconFull:Class = UpgradeIndicator_bitmapUpgradeIconFull;
      
      private static const upgradeIconFullBd:BitmapData = new bitmapUpgradeIconFull().bitmapData;
      
      private static const bitmapUpgradeIconEmpty:Class = UpgradeIndicator_bitmapUpgradeIconEmpty;
      
      private static const upgradeIconEmptyBd:BitmapData = new bitmapUpgradeIconEmpty().bitmapData;
      
      private static const bitmapUpgradeIconM2:Class = UpgradeIndicator_m2Class;
      
      private static const upgradeIconEmptyBdM2:BitmapData = new bitmapUpgradeIconM2().bitmapData;
      
      private static const bitmapUpgradeIconM3:Class = UpgradeIndicator_m3Class;
      
      private static const upgradeIconEmptyBdM3:BitmapData = new bitmapUpgradeIconM3().bitmapData;
       
      
      private var cells:Array;
      
      private var space:int = 2;
      
      private var cellsNum:int = 1;
      
      private var _value:int;
      
      public function UpgradeIndicator()
      {
         var cell:Bitmap = null;
         var i:int = 0;
         super();
         this.cells = new Array();
         while(i < this.cellsNum)
         {
            cell = new Bitmap(upgradeIconEmptyBd);
            addChild(cell);
            this.cells.push(cell);
            cell.x = i * (cell.width + this.space);
            i++;
         }
      }
      
      public function set value(v:int) : void
      {
         var cell:Bitmap = null;
         var i:int = 0;
		 this._value = v;
         /*if(v > this.cellsNum)
         {
            this._value = this.cellsNum;
         }
         else if(v < 0)
         {
            this._value = 0;
         }
         else
         {
            this._value = v;
         }
         while(i < this.cellsNum)
         {
            cell = this.cells[i] as Bitmap;
            if(i < this._value)
            {
               cell.bitmapData = upgradeIconFullBd;
            }
            else
            {
               cell.bitmapData = upgradeIconEmptyBd;
            }
            i++;
         }*/
		 cell = this.cells[0] as Bitmap;
		 if(this._value == 0)
         {
           cell.bitmapData = upgradeIconEmptyBd;
         }
         else if(this._value == 1)
         {
           cell.bitmapData = upgradeIconFullBd;
         }
		 else if(this._value == 2)
         {
           cell.bitmapData = upgradeIconEmptyBdM2;
         }
		 else if(this._value == 3)
         {
           cell.bitmapData = upgradeIconEmptyBdM3;
         }
      }
   }
}
