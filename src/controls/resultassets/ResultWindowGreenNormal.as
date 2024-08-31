package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_NORMAL_GREEN_TL;
    import assets.resultwindow.bres_NORMAL_GREEN_PIXEL;

    public class ResultWindowGreenNormal extends StatLineBase
    {

        public function ResultWindowGreenNormal()
        {
            tl = new bres_NORMAL_GREEN_TL(1, 1);
            px = new bres_NORMAL_GREEN_PIXEL(1, 1);
        }
    }
}
