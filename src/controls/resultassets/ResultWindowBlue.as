package controls.resultassets
{
    import assets.resultwindow.bres_BG_BLUE_TL;
    import assets.resultwindow.bres_BG_BLUE_PIXEL;

    public class ResultWindowBlue extends ResultWindowBase
    {

        public function ResultWindowBlue()
        {
            tl = new bres_BG_BLUE_TL(1, 1);
            px = new bres_BG_BLUE_PIXEL(1, 1);
        }
    }
}
