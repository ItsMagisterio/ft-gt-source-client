﻿// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// utils.FlipBitmapDataUtils

package utils
{
    import flash.display.BitmapData;

    public class FlipBitmapDataUtils
    {

        public static function flipH(param1:BitmapData):BitmapData
        {
            var _loc4_:int;
            var _loc2_:BitmapData = new BitmapData(param1.width, param1.height, true);
            var _loc3_:int;
            while (_loc3_ < param1.width)
            {
                _loc4_ = 0;
                while (_loc4_ < param1.height)
                {
                    _loc2_.setPixel32(_loc3_, _loc4_, param1.getPixel32(((param1.width - 1) - _loc3_), _loc4_));
                    _loc4_++;
                }
                _loc3_++;
            }
            return (_loc2_);
        }
        public static function flipW(param1:BitmapData):BitmapData
        {
            var _loc4_:int;
            var _loc2_:BitmapData = new BitmapData(param1.width, param1.height, true);
            var _loc3_:int;
            while (_loc3_ < param1.width)
            {
                _loc4_ = 0;
                while (_loc4_ < param1.height)
                {
                    _loc2_.setPixel32(_loc3_, _loc4_, param1.getPixel32(_loc3_, ((param1.height - 1) - _loc4_)));
                    _loc4_++;
                }
                _loc3_++;
            }
            return (_loc2_);
        }

    }
} // package utils