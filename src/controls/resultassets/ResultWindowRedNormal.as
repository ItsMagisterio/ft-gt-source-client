package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_NORMAL_RED_TL;
    import assets.resultwindow.bres_NORMAL_RED_PIXEL;

    public class ResultWindowRedNormal extends StatLineBase
    {

        public function ResultWindowRedNormal()
        {
            tl = new bres_NORMAL_RED_TL(1, 1);
            px = new bres_NORMAL_RED_PIXEL(1, 1);
        }
    }
}
