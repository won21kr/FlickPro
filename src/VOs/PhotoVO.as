package VOs
{
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.Photo;
	
	import flash.display.Bitmap;

	public class PhotoVO
	{
		public var largeImage:Bitmap;
		public var smallImage:Bitmap;
		public var service:FlickrService;
		public var photo:Photo;
		
		public function PhotoVO()
		{
		
		}
	}
}