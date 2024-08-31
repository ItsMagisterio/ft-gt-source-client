package alternativa.tanks.models.weapon.gauss.sfx
{
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import flash.display.BlendMode;

   public class GaussFlame extends Mesh
   {

      public function GaussFlame(param1:Number, param2:Material)
      {
         super();
         var _loc3_:Vertex = addVertex(-param1 / 2, param1, 0, 0, 0);
         var _loc4_:Vertex = addVertex(-param1 / 2, 0, 0, 0, 1);
         var _loc5_:Vertex = addVertex(param1 / 2, 0, 0, 1, 1);
         var _loc6_:Vertex = addVertex(param1 / 2, param1, 0, 1, 0);
         addQuadFace(_loc3_, _loc4_, _loc5_, _loc6_, param2);
         calculateFacesNormals();
         calculateBounds();
         blendMode = BlendMode.SCREEN;
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
         useShadowMap = false;
         useLight = false;
      }
   }
}
