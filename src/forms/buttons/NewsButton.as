package forms.buttons
{
    import controls.DefaultButton;
    import flash.display.Bitmap;
    import controls.Label;
    import flash.filters.DropShadowFilter;

    public class NewsButton extends DefaultButton
    {

        private static const image:Class = NewsButton_image;

        private var img:Bitmap = new Bitmap(new image().bitmapData);

        public function NewsButton(name:String)
        {
            var label:Label;
            super();
            this.img.x = (this.img.y = 6);
            addChild(this.img);
            label = new Label();
            label.mouseEnabled = false;
            label.text = name;
            label.filters = [new DropShadowFilter(1, 45, 0, 0.7, 1, 1, 1)];
            label.x = ((this.img.x + this.img.width) + 11);
            label.y = ((this.height / 2) - (this.img.height / 2));
            this.addChild(label);
        }
    }
}
