﻿package alternativa.tanks.models.sfx.colortransform
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.struct.ColorTransformStruct;

    public class ColorTransformEntry
    {

        public var t:Number;
        public var redMultiplier:Number;
        public var greenMultiplier:Number;
        public var blueMultiplier:Number;
        public var alphaMultiplier:Number;
        public var redOffset:int;
        public var greenOffset:int;
        public var blueOffset:int;
        public var alphaOffset:int;

        public function ColorTransformEntry(cts:ColorTransformStruct)
        {
            this.t = cts.t;
            this.redMultiplier = cts.redMultiplier;
            this.greenMultiplier = cts.greenMultiplier;
            this.blueMultiplier = cts.blueMultiplier;
            this.alphaMultiplier = cts.alphaMultiplier;
            this.redOffset = cts.redOffset;
            this.greenOffset = cts.greenOffset;
            this.blueOffset = cts.blueOffset;
            this.alphaOffset = cts.alphaOffset;
        }
    }
}
