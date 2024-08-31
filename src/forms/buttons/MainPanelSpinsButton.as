package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelSpinsButton extends MainPanelWideButton
    {

        private static const iconN:Class = MainPanelSpinsButton_iconN;
        private static const overBtn:Class = MainPanelSpinsButton_overBtn;
        private static const normalBtn:Class = MainPanelSpinsButton_normalBtn;

        public function MainPanelSpinsButton()
        {
            super(new Bitmap(new iconN().bitmapData), 3, 3, new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
