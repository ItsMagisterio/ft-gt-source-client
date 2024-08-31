package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_NORMAL_BLUE_TL;
    import assets.resultwindow.bres_NORMAL_BLUE_PIXEL;

    public class ResultWindowBlueNormal extends StatLineBase
    {

        public function ResultWindowBlueNormal()
        {
            tl = new bres_NORMAL_BLUE_TL(1, 1);
            px = new bres_NORMAL_BLUE_PIXEL(1, 1);
        }
    }
}
