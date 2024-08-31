package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelSocialNetsButton extends MainPanelWideButton
    {

        private static const iconN:Class = MainPanelSocialNetsButton_iconN;
        private static const overBtn:Class = MainPanelSocialNetsButton_overBtn;
        private static const normalBtn:Class = MainPanelSocialNetsButton_normalBtn;

        public function MainPanelSocialNetsButton()
        {
            super(new Bitmap(new iconN().bitmapData), 3, 3, new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
