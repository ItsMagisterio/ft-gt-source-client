package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelDonateButton extends MainPanelWideButton
    {

        private static const iconN:Class = MainPanelDonateButton_iconN;
        private static const overBtn:Class = MainPanelDonateButton_overBtn;
        private static const normalBtn:Class = MainPanelDonateButton_normalBtn;

        public function MainPanelDonateButton()
        {
            super(new Bitmap(new iconN().bitmapData), 3, 3, new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
