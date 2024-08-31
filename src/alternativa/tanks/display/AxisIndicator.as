package alternativa.tanks.display
{
    import flash.display.Shape;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Camera3D;
    import __AS3__.vec.*;
    import alternativa.engine3d.alternativa3d;
    use namespace alternativa3d;

    public class AxisIndicator extends Shape
    {

        private var _size:int;
        private var axis1:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 0, 0]);

        public function AxisIndicator(size:int)
        {
            this._size = size;
        }
        public function update(camera:Camera3D):void
        {
            var kx:Number = NaN;
            var ky:Number = NaN;
            graphics.clear();
            camera.composeMatrix();
            this.axis1[0] = camera.ma;
            this.axis1[1] = camera.mb;
            this.axis1[2] = camera.me;
            this.axis1[3] = camera.mf;
            this.axis1[4] = camera.mi;
            this.axis1[5] = camera.mj;
            var i:int;
            var bitOffset:int = 16;
            while (i < 6)
            {
                kx = (this.axis1[i] + 1);
                ky = (this.axis1[int((i + 1))] + 1);
                graphics.lineStyle(0, (0xFF << bitOffset));
                graphics.moveTo(this._size, this._size);
                graphics.lineTo((this._size * kx), (this._size * ky));
                i = (i + 2);
                bitOffset = (bitOffset - 8);
            }
        }
        public function get size():int
        {
            return (this._size);
        }

    }
}
