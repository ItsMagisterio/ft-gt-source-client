package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_SELECTED_GREEN_TL;
    import assets.resultwindow.bres_SELECTED_GREEN_PIXEL;

    public class ResultWindowGreenSelected extends StatLineBase
    {

        public function ResultWindowGreenSelected()
        {
            tl = new bres_SELECTED_GREEN_TL(1, 1);
            px = new bres_SELECTED_GREEN_PIXEL(1, 1);
            frameColor = 5898034;
        }
    }
}
