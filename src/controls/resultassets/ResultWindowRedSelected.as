package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_SELECTED_RED_TL;
    import assets.resultwindow.bres_SELECTED_RED_PIXEL;

    public class ResultWindowRedSelected extends StatLineBase
    {

        public function ResultWindowRedSelected()
        {
            tl = new bres_SELECTED_RED_TL(1, 1);
            px = new bres_SELECTED_RED_PIXEL(1, 1);
            frameColor = 16673333;
        }
    }
}
