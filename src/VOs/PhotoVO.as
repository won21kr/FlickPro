package VOs
{
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.Photo;
	import com.adobe.webapis.flickr.PhotoContext;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class PhotoVO
	{
		public var image:Bitmap;
		public var service:FlickrService;
		public var photo:Photo;
		public var title:String;
		public var tags:String;
		
		public function PhotoVO(photo:Photo)
		{
			this.photo = photo;
			load();
		}
		
		private function load():void{
			var imageURL:String = 	'http://static.flickr.com/' + 
				photo.server + '/' + 
				photo.id + '_' +
				photo.secret + '.jpg';
			var request:URLRequest = new URLRequest(imageURL);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onEventComplete);
			loader.load(request);
		}
		
		private function onEventComplete(event:Event):void{
			var image:Bitmap = event.currentTarget.content;
			this.image = image;

		}
	}
}