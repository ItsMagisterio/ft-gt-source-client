package alternativa.tanks.utils.objectpool
{
	public class Pool
	{

		private var objects:Vector.<Object>;

		private var numObjects:int;

		function Pool()
		{
			this.objects = new Vector.<Object>();
			super();
		}

		public function getObject():Object
		{
			if (this.numObjects == 0)
			{
				return null;
			}
			var object:Object = this.objects[-- this.numObjects];
			this.objects[this.numObjects] = null;
			return object;
		}

		public function putObject(object:Object):void
		{
			var _loc2_:* = this.numObjects++;
			this.objects[_loc2_] = object;
		}

		public function clear():void
		{
			this.objects.length = 0;
			this.numObjects = 0;
		}
	}
}
