package alternativa.tanks.vehicles.tanks
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.IRayCollisionFilter;

   class RayCollisionFilter implements IRayCollisionFilter
   {

      private var body:Body;

      function RayCollisionFilter(param1:Body)
      {
         super();
         this.body = param1;
      }

      public function considerBody(param1:Body):Boolean
      {
         return this.body != param1;
      }
   }
}
