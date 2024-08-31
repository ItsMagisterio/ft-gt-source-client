




package alternativa.tanks.models.battlefield.gui.statistics.messages{
    import alternativa.tanks.models.battlefield.common.MessageLine;
    import controls.Label;
    import controls.rangicons.RangIconSmall;
    import alternativa.tanks.models.battlefield.common.MessageContainer;
    import flash.events.MouseEvent;
	import forms.ranks.SmallRankIcon;
    import projects.tanks.client.battlefield.gui.models.statistics.UserStat;
    import flash.system.System;
    import flash.display.Bitmap;

    public class UserActionImageLine extends MessageLine {

        private var userName:String;

		[Embed(source="railgun.png")]
		private static var rail:Class;
		private var railBMP:Bitmap = new rail();

		[Embed(source="fire.png")]
		private static var fire:Class;
		private var fireBMP:Bitmap = new fire();

		[Embed(source="freeze.png")]
		private static var freeze:Class;
		private var freezeBMP:Bitmap = new freeze();

		[Embed(source="hammer.png")]
		private static var hammer:Class;
		private var hammerBMP:Bitmap = new hammer();

		[Embed(source="mine.png")]
		private static var mine:Class;
		private var mineBMP:Bitmap = new mine();

		[Embed(source="twins.png")]
		private static var twins:Class;
		private var twinsBMP:Bitmap = new twins();

		[Embed(source="thunder.png")]
		private static var thunder:Class;
		private var thunderBMP:Bitmap = new thunder();

		[Embed(source="striker.png")]
		private static var striker:Class;
		private var strikerBMP:Bitmap = new striker();

		[Embed(source="smoky.png")]
		private static var smoky:Class;
		private var smokyBMP:Bitmap = new smoky();

		[Embed(source="vulcan.png")]
		private static var vulcan:Class;
		private var vulcanBMP:Bitmap = new vulcan();

		[Embed(source="shaft.png")]
		private static var shaft:Class;
		private var shaftBMP:Bitmap = new shaft();

		[Embed(source="rico.png")]
		private static var rico:Class;
		private var ricoBMP:Bitmap = new rico();

		[Embed(source="isida.png")]
		private static var isida:Class;
		private var isidaBMP:Bitmap = new isida();

        private var displayBMP:Bitmap = new Bitmap();

        public function UserActionImageLine(userStat:UserStat, actionText:String, affectedUserSrat:UserStat=null){
            var nickLabelSharpness:int;
            var label:Label;
            var rankIcon:SmallRankIcon;
            super();
            var nickLabelThickness:int = 50;
            nickLabelSharpness = 0;
            createImage(actionText);
            if (userStat != null){
                this.userName = userStat.name;
                rankIcon = new SmallRankIcon(userStat.rank, userStat.isPremium);
                rankIcon.x = (width + 4);
                rankIcon.y = 7;
                addChild(rankIcon);
                label = this.createLabel(userStat.name);
                label.thickness = nickLabelThickness;
                label.sharpness = nickLabelSharpness;
                label.x = ((rankIcon.x + rankIcon.width) - 3);
                label.y = 4;
                label.color = MessageContainer.getTeamFontColor(userStat.teamType);
                addChild(label);
                addEventListener(MouseEvent.CLICK, this.onMouseClick);
            }
            label = this.createLabel(" ");
            label.x = (width + 4);
            addChild(label);
            addChild(displayBMP);
            displayBMP.x = (width - 2);
            if (affectedUserSrat != null){
                rankIcon = new SmallRankIcon(affectedUserSrat.rank, affectedUserSrat.isPremium);
                rankIcon.x = (width + 8);
                rankIcon.y = 7;
                addChild(rankIcon);
                label = this.createLabel(affectedUserSrat.name);
                label.x = ((rankIcon.x + rankIcon.width) - 3);
                label.y = 4;
                label.color = MessageContainer.getTeamFontColor(affectedUserSrat.teamType);
                label.thickness = nickLabelThickness;
                label.sharpness = nickLabelSharpness;
                addChild(label);
            }
        }
        private function onMouseClick(event:MouseEvent):void{
            System.setClipboard(this.userName);
        }
        private function createLabel(text:String):Label{
            var label:Label = new Label();
            label.mouseEnabled = false;
            label.text = text;
            return (label);
        }

        private function createImage(param1:String):void{
            if(param1.indexOf("rail") >= 0){
                displayBMP.bitmapData = railBMP.bitmapData;
            }else if(param1.indexOf("smoky") >= 0){
                displayBMP.bitmapData = smokyBMP.bitmapData;
            }else if(param1.indexOf("isida") >= 0){
                displayBMP.bitmapData = isidaBMP.bitmapData;
            }else if(param1.indexOf("fre") >= 0){
                displayBMP.bitmapData = freezeBMP.bitmapData;
            }else if(param1.indexOf("shaft") >= 0){
                displayBMP.bitmapData = shaftBMP.bitmapData;
            }else if(param1.indexOf("fire") >= 0){
                displayBMP.bitmapData = fireBMP.bitmapData;
            }else if(param1.indexOf("flame") >= 0){
                displayBMP.bitmapData = fireBMP.bitmapData;
            }else if(param1.indexOf("rico") >= 0){
                displayBMP.bitmapData = ricoBMP.bitmapData;
            }else if(param1.indexOf("isida") >= 0){
                displayBMP.bitmapData = isidaBMP.bitmapData;
            }else if(param1.indexOf("vulcan") >= 0){
                displayBMP.bitmapData = vulcanBMP.bitmapData;
            }else if(param1.indexOf("thunder") >= 0){
                displayBMP.bitmapData = thunderBMP.bitmapData;
            }else if(param1.indexOf("twins") >= 0){
                displayBMP.bitmapData = twinsBMP.bitmapData;
            }else if(param1.indexOf("mine") >= 0){
                displayBMP.bitmapData = mineBMP.bitmapData;
            }
        }

    }
}

