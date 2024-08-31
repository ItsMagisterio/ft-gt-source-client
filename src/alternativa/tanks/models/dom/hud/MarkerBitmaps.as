package alternativa.tanks.models.dom.hud
{
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.dom.sfx.PointState;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class MarkerBitmaps
    {

        private static const blueMarkerClass:Class = MarkerBitmaps_blueMarkerClass;
        private static const blueMarkerBitmapData:BitmapData = new blueMarkerClass().bitmapData;
        private static const grayMarkerClass:Class = MarkerBitmaps_grayMarkerClass;
        private static const grayMarkerBitmapData:BitmapData = new grayMarkerClass().bitmapData;
        private static const redMarkerClass:Class = MarkerBitmaps_redMarkerClass;
        private static const redMarkerBitmapData:BitmapData = new redMarkerClass().bitmapData;
        private static const letters:Class = MarkerBitmaps_letters;
        private static const markerBitmaps:Dictionary = new Dictionary();
        private static const markerWidth:int = redMarkerBitmapData.width;
        private static const letterBar:BitmapData = new letters().bitmapData;
        private static const letterBitmaps:Dictionary = new Dictionary();

        {
            markerBitmaps[PointState.NEUTRAL] = grayMarkerBitmapData;
            markerBitmaps[PointState.BLUE] = blueMarkerBitmapData;
            markerBitmaps[PointState.RED] = redMarkerBitmapData;
        }
        public static function getMarkerBitmapData(param1:PointState):BitmapData
        {
            return (markerBitmaps[param1]);
        }
        public static function getLetterImage(param1:String):BitmapData
        {
            var _loc2_:Number = (param1.charCodeAt(0) - "A".charCodeAt(0));
            var _loc3_:BitmapData = letterBitmaps[_loc2_];
            if (_loc3_ == null)
            {
                _loc3_ = new BitmapData(markerWidth, letterBar.height, true, 0);
                _loc3_.copyPixels(letterBar, new Rectangle((_loc2_ * markerWidth), 0, markerWidth, letterBar.height), new Point());
                letterBitmaps[_loc2_] = _loc3_;
            }
            return (_loc3_);
        }

    }
}
