package alternativa.tanks
{
    import alternativa.engine3d.objects.Mesh;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.core.Sorting;
    import alternativa.engine3d.core.Clipping;
    import __AS3__.vec.*;

    public class Polygon extends Mesh
    {

        public function Polygon(vertices:Vector.<Number>, uv:Vector.<Number>, twoSided:Boolean)
        {
            var numVertices:int = int((vertices.length / 3));
            var indices:Vector.<int> = new Vector.<int>((numVertices + 1));
            indices[0] = numVertices;
            var i:int;
            while (i < numVertices)
            {
                indices[(i + 1)] = i;
                i++;
            }
            addVerticesAndFaces(vertices, uv, indices, true);
            if (twoSided)
            {
            }
            calculateFacesNormals();
            calculateBounds();
            sorting = Sorting.DYNAMIC_BSP;
            clipping = Clipping.FACE_CLIPPING;
        }
    }
}
