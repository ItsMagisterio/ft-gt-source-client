package controls.resultassets
{
    import controls.statassets.StatLineBase;
    import assets.resultwindow.bres_HEADER_RED_TL;
    import assets.resultwindow.bres_HEADER_RED_PIXEL;

    public class ResultWindowRedHeader extends StatLineBase
    {

        public function ResultWindowRedHeader()
        {
            tl = new bres_HEADER_RED_TL(1, 1);
            px = new bres_HEADER_RED_PIXEL(1, 1);
        }
    }
}
