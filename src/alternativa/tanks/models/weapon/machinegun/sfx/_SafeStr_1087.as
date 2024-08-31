// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_1087

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.core.Vertex;
    import flash.display.BlendMode;
    import alternativa.engine3d.materials.TextureMaterial;

    public class _SafeStr_1087 extends Mesh
    {

        private static const _SafeStr_1826:Number = 15000;

        private var a:Vertex;
        private var b:Vertex;
        private var c:Vertex;
        private var d:Vertex;
        private var _SafeStr_6564:Number;
        private var offset:Number = 0;

        public function _SafeStr_1087()
        {
            this.a = addVertex(-1, 1, -5);
            this.b = addVertex(-1, 0, -5);
            this.c = addVertex(1, 0, -5);
            this.d = addVertex(1, 1, -5);
            addQuadFace(this.a, this.b, this.c, this.d);
            calculateFacesNormals();
            blendMode = BlendMode.ADD;
            useLight = false;
            shadowMapAlphaThreshold = 2;
            depthMapAlphaThreshold = 2;
            useShadowMap = false;
        }

        public function init(_arg_1:TextureMaterial):void
        {
            _arg_1.repeat = true;
            var _local_2:Number = (30 * 0.5);
            this.a.x = -(_local_2);
            this.a.u = 0;
            this.b.x = -(_local_2);
            this.b.u = 0;
            this.c.x = _local_2;
            this.c.u = 1;
            this.d.x = _local_2;
            this.d.u = 1;
            this._SafeStr_6564 = (((4 * 30) * _arg_1.texture.height) / _arg_1.texture.width);
            setMaterialToAllFaces(_arg_1);
            this.offset = 0;
        }

        public function update(_arg_1:int, _arg_2:Number = 0x0200):void
        {
            this.offset = (this.offset + ((15000 * _arg_1) / 1000));
            this.a.y = _arg_2;
            this.d.y = _arg_2;
            this.b.v = (1 + (this.offset / this._SafeStr_6564));
            this.c.v = this.b.v;
            this.a.v = (this.b.v - (_arg_2 / this._SafeStr_6564));
            this.d.v = this.a.v;
        }

    }
} // package alternativa.tanks.models.weapon.machinegun.sfx

// _SafeStr_1087 = "6\"^" (String#21, DoABC#1959)
// _SafeStr_1826 = "!#i" (String#55, DoABC#1959)
// _SafeStr_6564 = " I" (String#20, DoABC#1959)