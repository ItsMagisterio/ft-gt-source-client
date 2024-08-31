package alternativa.proplib.objects
{
    import alternativa.engine3d.core.Object3D;

    public class PropObject
    {

        public var object:Object3D;
        private var _type:int;

        public function PropObject(_arg_1:int)
        {
            this._type = _arg_1;
        }
        public function get type():int
        {
            return (this._type);
        }
        public function traceProp():void
        {
            trace(this.object);
        }

    }
}
