package forms.stat
{
    import controls.Label;
    import flash.display.Sprite;
    import forms.ranks.SmallRankIcon;

    import alternativa.init.Main;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import controls.Money;
    import controls.statassets.ReferalStatLineBackgroundNormal;
    import flash.display.DisplayObject;
    import controls.statassets.ReferalStatLineBackgroundSelected;

    public class ReferralStatListRenderer extends StatListRenderer
    {

        override protected function myIcon(data:Object):Sprite
        {
            var name:Label;
            var info:Label;
            var cont:Sprite = new Sprite();
            var rangIcon:SmallRankIcon = new SmallRankIcon(data.rank, data.premium);
            name = new Label();
            Main.writeVarsToConsoleChannel("REFERALS MODEL", "in renderer name = %1, income = %2", data.callsign, data.income);
            if (data.rank > 0)
            {
                rangIcon.y = 3;
                rangIcon.x = 0;
                cont.addChild(rangIcon);
            }
            name.autoSize = TextFieldAutoSize.NONE;
            name.height = 18;
            name.text = data.callsign;
            name.x = 12;
            name.width = (_width - 72);
            cont.addChild(name);
            info = new Label();
            info.autoSize = TextFieldAutoSize.NONE;
            info.align = TextFormatAlign.RIGHT;
            info.width = 90;
            info.x = (_width - 100);
            info.text = ((data.income > -1) ? Money.numToString(data.income, false) : "null");
            cont.addChild(info);
            return (cont);
        }
        override public function set data(value:Object):void
        {
            _data = value;
            var nr:DisplayObject = new ReferalStatLineBackgroundNormal();
            var sl:DisplayObject = new ReferalStatLineBackgroundSelected();
            nicon = this.myIcon(_data);
            setStyle("upSkin", nr);
            setStyle("downSkin", nr);
            setStyle("overSkin", nr);
            setStyle("selectedUpSkin", sl);
            setStyle("selectedOverSkin", sl);
            setStyle("selectedDownSkin", sl);
        }

    }
}
