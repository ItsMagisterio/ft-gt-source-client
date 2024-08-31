package controls
{
    import flash.display.Graphics;

    public class BigButtonState extends ButtonState
    {

        override public function draw():void
        {
            var _local_1:Graphics;
            _local_1 = l.graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(bmpLeft);
            _local_1.drawRect(0, 0, 7, 50);
            _local_1.endFill();
            l.x = 0;
            l.y = 0;
            _local_1 = c.graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(bmpCenter);
            _local_1.drawRect(0, 0, (_width - 14), 50);
            _local_1.endFill();
            c.x = 7;
            c.y = 0;
            _local_1 = r.graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(bmpRight);
            _local_1.drawRect(0, 0, 7, 50);
            _local_1.endFill();
            r.x = (_width - 7);
            r.y = 0;
        }

    }
}
