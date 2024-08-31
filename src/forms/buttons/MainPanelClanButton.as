package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelClanButton extends MainPanelWideButton
    {

        private static const iconN:Class = MainPanelClanButton_iconN;
        private static const overBtn:Class = MainPanelClanButton_overBtn;
        private static const normalBtn:Class = MainPanelClanButton_normalBtn;

        public function MainPanelClanButton()
        {
            super(new Bitmap(new iconN().bitmapData), 3, 3, new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
