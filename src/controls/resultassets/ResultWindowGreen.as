package controls.resultassets
{
    import assets.resultwindow.bres_BG_GREEN_TL;
    import assets.resultwindow.bres_BG_GREEN_PIXEL;

    public class ResultWindowGreen extends ResultWindowBase
    {

        public function ResultWindowGreen()
        {
            tl = new bres_BG_GREEN_TL(1, 1);
            px = new bres_BG_GREEN_PIXEL(1, 1);
        }
    }
}
