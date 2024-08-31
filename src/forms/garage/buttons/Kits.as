package forms.garage.buttons
{
    import controls.DefaultButton;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import controls.Label;

    public class Kits extends DefaultButton
    {

        private static var add:Class = Kits_add;

        private var icon1:MovieClip = new MovieClip();
        private var i:Bitmap = new add();
        private var i1:MainPanelBattlesButton = new MainPanelBattlesButton();
        private var f:Label = new Label();

        public function Kits(text:String)
        {
            this.f.mouseEnabled = false;
            this.width = 100;
            this.height = this.i1.height;
            this.i.x = 6;
            this.i.y = 6;
            this.addChild(this.i);
            this.f.text = text;
            this.f.x = ((this.i.x + this.i.width) + 2);
            this.f.y = ((this.height / 2) - (this.f.height / 2));
            this.addChild(this.f);
        }
    }
}
