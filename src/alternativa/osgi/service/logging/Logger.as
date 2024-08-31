package alternativa.osgi.service.logging
{
	import specter.utils.Logger;

	/**
	 * ...
	 * @author Colly
	 */
	public class Logger
	{

		public function Logger()
		{

		}

		public function error(msg:String, msg1:Array = null):void
		{
			specter.utils.Logger.warn(msg, msg1.join('/n'));
		}

		public function info(msg:String, msg1:Array = null):void
		{
			specter.utils.Logger.log(msg, msg1.join('/n'));
		}

	}

}