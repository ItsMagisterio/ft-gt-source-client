package alternativa.osgi.service.logging
{
	/**
	 * ...
	 * @author Colly
	 */
	public class LogService extends Logger
	{

		public function LogService()
		{

		}

		public function getLogger(param1:String):Logger
		{
			return new Logger();
		}

	}

}