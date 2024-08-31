package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_HEADER_BLUE_TL;
    import assets.resultwindow.bres_HEADER_BLUE_PIXEL;

    public class ResultWindowBlueHeader extends StatLineBase
    {

        public function ResultWindowBlueHeader()
        {
            tl = new bres_HEADER_BLUE_TL(1, 1);
            px = new bres_HEADER_BLUE_PIXEL(1, 1);
        }
    }
}
