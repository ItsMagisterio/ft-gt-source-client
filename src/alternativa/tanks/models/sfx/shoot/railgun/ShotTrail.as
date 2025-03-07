﻿package alternativa.tanks.models.sfx.shoot.railgun
{
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Face;
    import alternativa.engine3d.core.Sorting;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.materials.Material;

    public class ShotTrail extends Mesh
    {

        private var a:Vertex;
        private var b:Vertex;
        private var c:Vertex;
        private var d:Vertex;
        private var face:Face;
        private var bottomV:Number;
        private var distanceV:Number;

        public function ShotTrail()
        {
            this.a = addVertex(-1, 1, 0);
            this.b = addVertex(-1, 0, 0);
            this.c = addVertex(1, 0, 0);
            this.d = addVertex(1, 1, 0);
            this.face = addQuadFace(this.a, this.b, this.c, this.d);
            calculateFacesNormals();
            sorting = Sorting.DYNAMIC_BSP;
            softAttenuation = 80;
            shadowMapAlphaThreshold = 2;
            depthMapAlphaThreshold = 2;
            useShadowMap = false;
            useLight = false;
        }
        public function init(boundMaxXAxis:Number, boundMaxYAxis:Number, material:Material, distanceVNum:Number):void
        {
            var _loc5_:Number = (boundMaxXAxis * 0.5);
            this.a.x = -(_loc5_);
            this.a.y = boundMaxYAxis;
            this.a.u = 0;
            this.b.x = -(_loc5_);
            this.b.y = 0;
            this.b.u = 0;
            this.c.x = _loc5_;
            this.c.y = 0;
            this.c.u = 1;
            this.d.x = _loc5_;
            this.d.y = boundMaxYAxis;
            this.d.u = 1;
            boundMinX = -(_loc5_);
            boundMinY = 0;
            boundMinZ = 0;
            boundMaxX = _loc5_;
            boundMaxY = boundMaxYAxis;
            boundMaxZ = 0;
            this.face.material = material;
            var _loc6_:TextureMaterial = (material as TextureMaterial);
            if (((!(_loc6_ == null)) && (!(_loc6_.texture == null))))
            {
                this.bottomV = (boundMaxYAxis / ((boundMaxXAxis * _loc6_.texture.height) / _loc6_.texture.width));
                this.distanceV = (distanceVNum / boundMaxXAxis);
            }
            else
            {
                this.bottomV = 1;
                this.distanceV = 0;
            }
        }
        public function clear():void
        {
            this.face.material = null;
        }
        public function update(param1:Number):void
        {
            var _loc2_:Number = (this.distanceV * param1);
            this.a.v = _loc2_;
            this.b.v = (this.bottomV + _loc2_);
            this.c.v = (this.bottomV + _loc2_);
            this.d.v = _loc2_;
        }

    }
}
