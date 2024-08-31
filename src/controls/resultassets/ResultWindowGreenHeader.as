package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_HEADER_GREEN_TL;
    import assets.resultwindow.bres_HEADER_GREEN_PIXEL;

    public class ResultWindowGreenHeader extends StatLineBase
    {

        public function ResultWindowGreenHeader()
        {
            tl = new bres_HEADER_GREEN_TL(1, 1);
            px = new bres_HEADER_GREEN_PIXEL(1, 1);
        }
    }
}
