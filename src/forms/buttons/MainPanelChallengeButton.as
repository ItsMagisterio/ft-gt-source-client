package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelChallengeButton extends MainPanelWideButton
    {

        private static const iconN:Class = MainPanelChallengeButton_iconN;
        private static const overBtn:Class = MainPanelChallengeButton_overBtn;
        private static const normalBtn:Class = MainPanelChallengeButton_normalBtn;

        public function MainPanelChallengeButton()
        {
            super(new Bitmap(new iconN().bitmapData), 3, 4, new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
