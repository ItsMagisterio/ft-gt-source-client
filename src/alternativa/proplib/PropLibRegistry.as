package alternativa.proplib
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class PropLibRegistry
    {

        private var libs:Object = {}

        public function addLibrary(lib:PropLibrary):void
        {
            this.libs[lib.name] = lib;
        }
        public function destroy(b:Boolean = false):*
        {
            var lib:PropLibrary;
            for each (lib in this.libs)
            {
                lib.freeMemory();
                lib = null;
            }
        }
        public function getLibrary(libName:String):PropLibrary
        {
            return (this.libs[libName]);
        }
        public function get libraries():Vector.<PropLibrary>
        {
            var lib:PropLibrary;
            var res:Vector.<PropLibrary> = new Vector.<PropLibrary>();
            for each (lib in this.libs)
            {
                res.push(lib);
            }
            return (res);
        }

    }
}
