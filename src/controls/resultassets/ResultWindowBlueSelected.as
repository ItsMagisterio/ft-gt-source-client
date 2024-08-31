package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_SELECTED_BLUE_TL;
    import assets.resultwindow.bres_SELECTED_BLUE_PIXEL;

    public class ResultWindowBlueSelected extends StatLineBase
    {

        public function ResultWindowBlueSelected()
        {
            tl = new bres_SELECTED_BLUE_TL(1, 1);
            px = new bres_SELECTED_BLUE_PIXEL(1, 1);
            frameColor = 7520742;
        }
    }
}
