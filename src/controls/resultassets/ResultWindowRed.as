package controls.resultassets
{
    import assets.resultwindow.bres_BG_RED_TL;
    import assets.resultwindow.bres_BG_RED_PIXEL;

    public class ResultWindowRed extends ResultWindowBase
    {

        public function ResultWindowRed()
        {
            tl = new bres_BG_RED_TL(1, 1);
            px = new bres_BG_RED_PIXEL(1, 1);
        }
    }
}
