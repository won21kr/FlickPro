package VOs
{
	import com.adobe.webapis.flickr.FlickrError;
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.Photo;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomEvent;
	import com.squidzoo.imageUtils.ImageCache;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import statics.Service;
	[Bindable]
	public class PhotoVO
	{
		public var image:Bitmap;
		public var service:FlickrService;
		public var photo:Photo;
		public var title:String;
		public var tags:Array = new Array();
		public var description:String;
		public var ownerName:String;
		public var isFamily:Boolean;
		public var isFavorite:Boolean;
		public var isPublic:Boolean;
		public var dateTaken:String;
		
		public var previousPhoto:PhotoVO;
		public var nextPhoto:PhotoVO;
		public var setTitle:String;
		public var setId:String;
		public var imageURL:String;
		public var largeImageString:String;
		public var id:String;
		
		private var _cache:ImageCache;
		
		private var _service:FlickrService;
		
		public function PhotoVO(photo:Photo)
		{
			_service = Service.getService();
			
			_cache = ImageCache.getInstance();
		
			this.id = photo.id;
			this.photo = photo;
			this.title = photo.title;
			this.description = photo.description;
			
			
			imageURL = buildSmallImageURL();
			largeImageString = buildLargeImageURL();	
			
			if(_cache.hasImageData(imageURL)){
				trace("is cached");
				displayImage(_cache.getImageData(imageURL));
			}else{
				trace("is not chached");
				load();
			}
		}
		
		private function buildSmallImageURL():String{
			var url:String = 	'http://static.flickr.com/' + 
			photo.server + '/' + 
			photo.id + '_' +
			photo.secret + '_s.jpg';
			return url;
		}
		
		private function buildLargeImageURL():String
		{
			var url:String = 	'http://static.flickr.com/' + 
				photo.server + '/' + 
				photo.id + '_' +
				photo.secret + '_z.jpg';
			return url;
		}
		
		private function load():void{
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
			
			if(_cache.hasImageData(imageURL)==false){
				_cache.putImageData(imageURL,image);
			}
			
			displayImage(image);
		}
		
		private function displayImage(image:Bitmap):void{
			this.image = image;
			loadMeta();
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.INVALIDATE_DISPLAY_LIST));
		}
		
		private function loadMeta():void{
			_service.addEventListener(FlickrResultEvent.PHOTOS_GET_INFO,onGetMeta);
			//_service.addEventListener(FlickrError.SERVICE_CURRENTLY_UNAVAILABLE,onServiceNotAvailable);
			_service.photos.getInfo(id);
		}
		
		protected function onGetMeta(event:FlickrResultEvent):void
		{
			// TODO Auto-generated method stub
			if(event.success && event.data && event.data.photo){
				
				if(event.data.photo.dateTaken) dateTaken = event.data.photo.dateTaken;
				if(event.data.photo.description) description = event.data.photo.description;
				if(event.data.photo.isFamily) isFamily = event.data.photo.isFamily;
				if(event.data.photo.isFavorite) isFavorite = event.data.photo.isFriend;
				if(event.data.photo.isPublic) isPublic = event.data.photo.isPublic
				if(event.data.photo.ownerName) ownerName = event.data.photo.ownerName;
				if(event.data.photo.tags) tags = event.data.photo.tags;
				if(event.data.photo.title) title = event.data.photo.title;
			}
		}		
		
	}
}