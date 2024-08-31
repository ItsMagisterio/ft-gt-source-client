package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import controls.Label;
    import assets.Diamond;

    import flash.text.TextFormatAlign;
    import alternativa.init.Main;
    import forms.ranks.SmallRankIcon;

    public class ModInfoRow extends Sprite
    {

        private const labelNormalColor:uint = 0xFFFFFF;
        private const labelSelectedColor:uint = 0xFFFFFF;
        public const h:int = 17;
        public const hSpace:int = 10;

        public var labels:Array;
        public var costLabel:Label;
        public var crystalIcon:Diamond;
        public var rankIcon:SmallRankIcon;
        public var upgradeIndicator:UpgradeIndicator;
        public var costWidth:int;

        public function ModInfoRow()
        {
            var label:Label;
            super();
            this.labels = new Array();
            var i:int;
            while (i < 8)
            {
                label = new Label();
                label.color = this.labelNormalColor;
                label.align = TextFormatAlign.CENTER;
                label.text = "ABC123";
                addChild(label);
                this.labels.push(label);
                label.y = ((this.h - label.height) >> 1);
                i++;
            }
            this.costLabel = new Label();
            this.costLabel.color = this.labelNormalColor;
            this.costLabel.align = TextFormatAlign.RIGHT;
            this.costLabel.text = "ABC123";
            addChild(this.costLabel);
            this.costLabel.y = ((this.h - this.costLabel.height) >> 1);
            this.crystalIcon = new Diamond();
            addChild(this.crystalIcon);
            this.crystalIcon.y = ((this.h - this.crystalIcon.height) >> 1);
            this.rankIcon = new SmallRankIcon();
            addChild(this.rankIcon);
            this.rankIcon.y = (((this.h - this.rankIcon.height) >> 1) + 1);
            this.upgradeIndicator = new UpgradeIndicator();
            addChild(this.upgradeIndicator);
            this.upgradeIndicator.y = (((this.h - this.upgradeIndicator.height) >> 1) + 1);
        }
        public function hideUpgradeIndicator():void
        {
            removeChild(this.upgradeIndicator);
        }
        public function select():void
        {
            var label:Label;
            var i:int;
            while (i < 8)
            {
                label = (this.labels[i] as Label);
                label.color = this.labelSelectedColor;
                label.sharpness = -100;
                label.thickness = 100;
                i++;
            }
            this.costLabel.color = this.labelSelectedColor;
            this.costLabel.sharpness = -100;
            this.costLabel.thickness = 100;
        }
        public function unselect():void
        {
            var label:Label;
            var i:int;
            while (i < 8)
            {
                label = (this.labels[i] as Label);
                label.color = this.labelNormalColor;
                label.sharpness = 50;
                label.thickness = -50;
                i++;
            }
            this.costLabel.color = this.labelNormalColor;
            this.costLabel.sharpness = 50;
            this.costLabel.thickness = -50;
        }
        public function setLabelsNum(num:int):void
        {
            var i:int;
            while (i < this.labels.length)
            {
                if (i < num)
                {
                    (this.labels[i] as Label).visible = true;
                }
                else
                {
                    (this.labels[i] as Label).visible = false;
                }
                i++;
            }
        }
        public function setLabelsText(text:Array):void
        {
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "setLabelsText: %1", text);
            var i:int;
            while (i < text.length)
            {
                if ((((!(text[i] == null)) && (!(text[i] == ""))) && (!(text[i] == "null"))))
                {
                    (this.labels[i] as Label).text = text[i];
                }
                else
                {
                    (this.labels[i] as Label).text = "—";
                }
                i++;
            }
        }
        public function setLabelsPos(coords:Array):void
        {
            var l:Label;
            var i:int;
            while (i < coords.length)
            {
                l = (this.labels[i] as Label);
                l.x = ((coords[i] - Math.round((l.textWidth * 0.5))) - 3);
                i++;
            }
        }
        public function setConstPartCoord(value:int):void
        {
            this.upgradeIndicator.x = value;
            this.rankIcon.x = ((this.upgradeIndicator.x + this.upgradeIndicator.width) + this.hSpace);
            this.costLabel.x = ((((this.rankIcon.x + this.rankIcon.width) + this.hSpace) + this.costWidth) - this.costLabel.width);
            this.crystalIcon.x = ((((this.rankIcon.x + this.rankIcon.width) + this.hSpace) + this.costWidth) + 3);
        }

    }
} // package alternativa.tanks.gui