package statics
{
	import com.adobe.webapis.flickr.FlickrService;

	public class Service
	{
		private static var service:FlickrService;
		
		public function Service()
		{
		}
		
		public static function setService(value:FlickrService):void{
			service = value;
		}
		
		public static function getService():FlickrService{
			return service;
		}
	}
}