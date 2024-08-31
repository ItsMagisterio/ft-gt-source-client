package forms.buttons
{
    import flash.display.Bitmap;

    public class MainPanelFriendsButton extends MainPanelWideButton
    {

        private static const iconN:Class = MainPanelFriendsButton_iconN;
        private static const overBtn:Class = MainPanelFriendsButton_overBtn;
        private static const normalBtn:Class = MainPanelFriendsButton_normalBtn;

        public function MainPanelFriendsButton()
        {
            super(new Bitmap(new iconN().bitmapData), 2, 2, new Bitmap(new overBtn().bitmapData), new Bitmap(new normalBtn().bitmapData));
        }
    }
}
