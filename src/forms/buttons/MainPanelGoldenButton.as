package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelGoldenButton extends MainPanelQuadButton
    {

        private static const overBtn:Class = MainPanelGoldenButton_overBtn;
        private static const normalBtn:Class = MainPanelGoldenButton_normalBtn;

        public function MainPanelGoldenButton()
        {
            super(new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
