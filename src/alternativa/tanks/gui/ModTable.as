package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import controls.Label;

    public class ModTable extends Sprite
    {

        private static const bitmapUpgradeSelectionLeft:Class = ModTable_bitmapUpgradeSelectionLeft;
        private static const selectionLeftBd:BitmapData = new bitmapUpgradeSelectionLeft().bitmapData;
        private static const bitmapUpgradeSelectionCenter:Class = ModTable_bitmapUpgradeSelectionCenter;
        private static const selectionCenterBd:BitmapData = new bitmapUpgradeSelectionCenter().bitmapData;
        private static const bitmapUpgradeSelectionRight:Class = ModTable_bitmapUpgradeSelectionRight;
        private static const selectionRightBd:BitmapData = new bitmapUpgradeSelectionRight().bitmapData;

        public const vSpace:int = 0;

        private var _maxCostWidth:int;
        public var constWidth:int;
        public var rows:Array;
        private var selection:Shape;
        private var selectedRowIndex:int = -1;
        private var xt:Boolean;
        private var rowCount:int = 4;

        public function ModTable()
        {
            var row:ModInfoRow;
            super();
            this.rows = new Array();
            this.selection = new Shape();
            addChild(this.selection);
            this.selection.x = 3;
            var i:int;
            while (i < this.rowCount)
            {
                row = new ModInfoRow();
                addChild(row);
                row.y = ((row.h + this.vSpace) * i);
                this.rows.push(row);
                row.upgradeIndicator.value = i;
                i++;
            }
        }
        public function changeRowCount(num:int):void
        {
            var row:ModInfoRow;
            var _row:ModInfoRow;
            var i:int;
            row = null;
            this.rowCount = num;
            for each (_row in this.rows)
            {
                removeChild(_row);
            }
            this.rows = new Array();
            i = 0;
            while (i < this.rowCount)
            {
                row = new ModInfoRow();
                if (num == 1)
                {
                    row.hideUpgradeIndicator();
                }
                addChild(row);
                row.y = ((row.h + this.vSpace) * i);
                this.rows.push(row);
                row.upgradeIndicator.value = i;
                i++;
            }
        }
        public function select(index:int):void
        {
            var row:ModInfoRow;
            if (this.selectedRowIndex != -1)
            {
                row = ModInfoRow(this.rows[this.selectedRowIndex]);
                if (row != null)
                {
                    row.unselect();
                }
            }
            this.selectedRowIndex = index;
            this.selection.y = ((ModInfoRow(this.rows[0]).h + this.vSpace) * index);
            row = ModInfoRow(this.rows[this.selectedRowIndex]);
            if (row != null)
            {
                row.select();
            }
        }
        public function resizeSelection(w:int):void
        {
            var width:int = (w - 6);
            var m:Matrix = new Matrix();
            this.selection.graphics.clear();
            this.selection.graphics.beginBitmapFill(selectionLeftBd);
            this.selection.graphics.drawRect(0, 0, selectionLeftBd.width, selectionLeftBd.height);
            this.selection.graphics.beginBitmapFill(selectionCenterBd);
            this.selection.graphics.drawRect(selectionLeftBd.width, 0, ((width - selectionLeftBd.width) - selectionRightBd.width), selectionCenterBd.height);
            m.tx = (width - selectionRightBd.width);
            this.selection.graphics.beginBitmapFill(selectionRightBd, m);
            this.selection.graphics.drawRect((width - selectionRightBd.width), 0, selectionRightBd.width, selectionRightBd.height);
        }
        public function correctNonintegralValues():void
        {
            var n:int;
            var label:Label;
            var index:int;
            var nonintegralIndexes:Array = new Array();
            var row:ModInfoRow = (this.rows[0] as ModInfoRow);
            var l:int = row.labels.length;
            var i:int;
            while (i < this.rowCount)
            {
                row = (this.rows[i] as ModInfoRow);
                n = 0;
                while (n < l)
                {
                    label = (row.labels[n] as Label);
                    if (label.text.indexOf(".") != -1)
                    {
                        nonintegralIndexes.push(n);
                    }
                    n++;
                }
                i++;
            }
            i = 0;
            while (i < this.rowCount)
            {
                row = this.rows[i];
                n = 0;
                while (n < nonintegralIndexes.length)
                {
                    index = nonintegralIndexes[n];
                    label = (row.labels[index] as Label);
                    if (label.text.indexOf(".") == -1)
                    {
                        label.text = (label.text + ".0");
                    }
                    n++;
                }
                i++;
            }
        }
        public function get maxCostWidth():int
        {
            return (this._maxCostWidth);
        }
        public function set maxCostWidth(value:int):void
        {
            this._maxCostWidth = value;
            var row:ModInfoRow = (this.rows[0] as ModInfoRow);
            this.constWidth = (((((row.upgradeIndicator.width + row.rankIcon.width) + 3) + row.crystalIcon.width) + this._maxCostWidth) + (row.hSpace * 3));
            var i:int;
            while (i < this.rowCount)
            {
                row = (this.rows[i] as ModInfoRow);
                row.costWidth = this._maxCostWidth;
                i++;
            }
        }

    }
} // package alternativa.tanks.gui