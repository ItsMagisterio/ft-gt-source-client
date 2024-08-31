package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelRatingButton extends MainPanelWideButton
    {

        private static const iconN:Class = MainPanelRatingButton_iconN;
        private static const overBtn:Class = MainPanelRatingButton_overBtn;
        private static const normalBtn:Class = MainPanelRatingButton_normalBtn;

        public function MainPanelRatingButton()
        {
            super(new Bitmap(new iconN().bitmapData), 3, 3, new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
