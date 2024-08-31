package alternativa.physics
{
    import alternativa.math.Vector3;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class Contact
    {

        private const MAX_POINTS:int = 8;

        public var body1:Body;
        public var body2:Body;
        public var restitution:Number;
        public var friction:Number;
        public var normal:Vector3 = new Vector3();
        public var points:Vector.<ContactPoint> = new Vector.<ContactPoint>(MAX_POINTS, true);
        public var pcount:int;
        public var maxPenetration:Number = 0;
        public var satisfied:Boolean;
        public var next:Contact;
        public var index:int;

        public function Contact(index:int)
        {
            this.index = index;
            var i:int;
            while (i < this.MAX_POINTS)
            {
                this.points[i] = new ContactPoint();
                i++;
            }
        }
        public function destroy():void
        {
            var c:ContactPoint;
            this.normal = null;
            if (this.points != null)
            {
                for each (c in this.points)
                {
                    c.destroy();
                    c = null;
                }
                this.points = null;
            }
        }

    }
}
