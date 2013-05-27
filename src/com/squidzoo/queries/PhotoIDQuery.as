package com.squidzoo.queries
{
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	import com.squidzoo.eventSystem.events.CustomEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import com.squidzoo.statics.NSID;
	import com.squidzoo.statics.Service;
	
	public class PhotoIDQuery extends EventDispatcher
	{
		private var _service:FlickrService;
		
		public function PhotoIDQuery(target:IEventDispatcher=null)
		{
			_service = Service.getService();
		}
		
		public function requestPhotoId():void{
			
			
			_service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream);
			_service.photos.search(NSID.getNSID(),
				"","any","",null,null,null,null,-1,"date-posted-desc",-1,"",
				-1,-1,-1,"","","","","","","",false,"","",-1,-1,"",50);
		}
		
		private function onGetPhotoStream(event:FlickrResultEvent):void{
			if(_service.hasEventListener(FlickrResultEvent.PHOTOS_SEARCH)){
				_service.removeEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream);
			}
			
			if(event.success){
				var photos:Array = event.data.photos.photos as Array;
				
				var firstPhotoId:String = photos[0].id;
				EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.FIRST_PHOTO_ID,null,null,firstPhotoId));
			
			}else{
				EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.FIRST_PHOTO_RETRIEVAL_ERROR));
			}
		}
	}
}