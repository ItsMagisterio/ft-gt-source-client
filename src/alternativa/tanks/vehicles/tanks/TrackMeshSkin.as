package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.tanks.materials.TrackMaterial;
   
   public class TrackMeshSkin
   {
      private const TEXTURE_TO_WORLD_RATIO:Number = 0.008;
      
      public var mesh:Mesh;
      
      private var sign:Number;
      
      private var material:TrackMaterial;
      
      private var offset:Number = 0;
      
      public function TrackMeshSkin(param1:Mesh, param2:Boolean)
      {
         super();
         this.mesh = param1;
         this.sign = param2 ? Number(-1) : Number(1);
      }
      
      public function move(param1:Number) : void
      {
         if(this.material != null)
         {
            this.offset = (this.offset - this.sign * param1 * this.TEXTURE_TO_WORLD_RATIO) % 1;
            this.material.uvMatrixProvider.getMatrix().tx = this.offset;
         }
      }
      
      public function setMaterial(param1:Material) : void
      {
         if(param1 instanceof TrackMaterial)
         {
            this.material = TrackMaterial(param1);
         }
         this.mesh.setMaterialToAllFaces(param1);
      }
   }
}
