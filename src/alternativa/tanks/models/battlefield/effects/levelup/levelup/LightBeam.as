﻿package alternativa.tanks.models.battlefield.effects.levelup.levelup
{
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.core.Vertex;
    import alternativa.engine3d.core.Sorting;
    import alternativa.engine3d.materials.TextureMaterial;

    public class LightBeam extends Mesh
    {

        public function LightBeam(param1:Number)
        {
            var _loc2_:Number = (param1 / 2);
            var _loc4_:Vertex = addVertex(-(_loc2_), 0, (param1 + 0), 0, 0);
            var _loc5_:Vertex = addVertex(-(_loc2_), 0, (0 + 0), 0, 1);
            var _loc6_:Vertex = addVertex(_loc2_, 0, (0 + 0), 1, 1);
            var _loc7_:Vertex = addVertex(_loc2_, 0, (param1 + 0), 1, 0);
            addQuadFace(_loc4_, _loc5_, _loc6_, _loc7_);
            sorting = Sorting.DYNAMIC_BSP;
            calculateBounds();
            calculateFacesNormals();
        }
        public function init(param1:TextureMaterial):void
        {
            setMaterialToAllFaces(param1);
        }
        public function clear():void
        {
            setMaterialToAllFaces(null);
        }

    }
}
