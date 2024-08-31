package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.objects.Mesh;

   public class Wheel
   {

      public var mesh:Mesh;

      private var diameter:Number;

      public function Wheel(mesh:Mesh)
      {
         super();
         this.mesh = mesh;
         this.diameter = mesh.boundMaxZ - mesh.boundMinZ;
      }

      public function rotate(rotation:Number):*
      {
         this.mesh.rotationX -= rotation / this.diameter;
      }
   }
}
