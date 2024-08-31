package alternativa.tanks.vehicles.tanks
{
	import alternativa.physics.Body;
	import alternativa.physics.collision.IRayCollisionPredicate;

	public class RayPredicate implements IRayCollisionPredicate
	{

		private var body:Body;

		public function RayPredicate(body:Body)
		{
			super();
			this.body = body;
		}

		public function considerBody(body:Body):Boolean
		{
			return this.body != body;
		}
	}

}