package alternativa.tanks.models.battlefield.gui.statistics.field
{
    import flash.display.Bitmap;

    public class DOMScoreIndicator extends TeamScoreFieldBase
    {

        private static const ICON_WIDTH:int = 21;
        private static const ICON_Y:int = 9;
        private static const icon_:Class = DOMScoreIndicator_icon_;

        private var icon:Bitmap = new Bitmap(new icon_().bitmapData);

        public function DOMScoreIndicator()
        {
            addChild(this.icon);
            this.icon.y = ICON_Y;
        }
        override protected function calculateWidth():int
        {
            var spacing:int = 5;
            var maxWidth:int = ((labelRed.width > labelBlue.width) ? int(labelRed.width) : int(labelBlue.width));
            labelRed.x = ((spacing + spacing) + ((maxWidth - labelRed.width) >> 1));
            this.icon.x = ((labelRed.x + maxWidth) + spacing);
            labelBlue.x = (((this.icon.x + ICON_WIDTH) + spacing) + ((maxWidth - labelBlue.width) >> 1));
            return (((labelBlue.x + maxWidth) + spacing) + spacing);
        }

    }
}
