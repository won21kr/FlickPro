package VOs
{
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.Photo;
	import com.adobe.webapis.flickr.PhotoContext;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class PhotoVO
	{
		public var image:Bitmap;
		public var service:FlickrService;
		public var photo:Photo;
		public var title:String;
		public var tags:String;
		public var largeImageString:String;
		
		public function PhotoVO(photo:Photo)
		{
			this.photo = photo;
			createStringForLargeImage();
			load();
		}
		
		private function createStringForLargeImage():void
		{
			largeImageString = 	'http://static.flickr.com/' + 
				photo.server + '/' + 
				photo.id + '_' +
				photo.secret + '.jpg';
		}
		
		private function load():void{
			var imageURL:String = 	'http://static.flickr.com/' + 
				photo.server + '/' + 
				photo.id + '_' +
				photo.secret + '_s.jpg';
			var request:URLRequest = new URLRequest(imageURL);
			var loader:Loader = new Loader();
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onEventComplete);
			loader.load(request);
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.INVALIDATE_DISPLAY_LIST));
		}
		
		private function onEventComplete(event:Event):void{
			var image:Bitmap = event.currentTarget.content;
			this.image = image;
			
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.INVALIDATE_DISPLAY_LIST));
		}
		
		
	}
}