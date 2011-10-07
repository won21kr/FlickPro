package queries
{
	import Interfaces.IPhotoQuery;
	
	import VOs.DataObject;
	import VOs.PhotoVO;
	
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	import com.squidzoo.eventSystem.events.CustomEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	import statics.NSID;
	import statics.Service;
	import statics.ViewTypes;
	
	public class PhotoQuery implements IPhotoQuery
	{
		[Bindable]
		private var _service:FlickrService;
		private var _numPhotos:int;
		private var _photoVOs:ArrayCollection;
		private var _id:String;
		private var _tags:String;
		
		public function PhotoQuery(){
		}
		
		public function setParams(dataObject:DataObject):void{
			if(dataObject.selectedSet){
				_id = dataObject.selectedSet.id;
			}
			if(dataObject.tags){
				_tags = dataObject.tags;
			}
			
			//trace("SetQuery.set params: _id :"+_id);
		}
		
		
		
		public function execute(str:String):void{
			_photoVOs = new ArrayCollection();
			_service = Service.getService();
		
			switch(str){
				case ViewTypes.SET:
					trace("get set");
					_service.photosets.getPhotos(_id); 
					_service.addEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS, onGetPhotoSet);  
					break;
			
				case ViewTypes.PHOTO_STREAM:
					trace("get stream");
					trace("NSID: "+NSID.getNSID());
					_service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream); 
					_service.photos.search(NSID.getNSID(),
						"","any","",null,null,null,null,-1,"date-posted-desc",-1,"",
						-1,-1,-1,"","","","","","","",false,"","",-1,-1,"",50);
					break;
					
				case ViewTypes.SEARCH_ALL_PUBLIC_PHOTOS_ON_FLICKR:
					_service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream); 
					_service.photos.search("", _tags);
					break;
				
				case ViewTypes.SEARCH_ONLY_OWN_PHOTOS:
					_service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream); 
					_service.photos.search(NSID.getNSID(), _tags);
			}
		}
		
		private function onGetPhotoSet(event:FlickrResultEvent):void{
			
			if(_service.hasEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS)){
				_service.removeEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS,onGetPhotoSet);
			}
			
			
				
			trace("an array of set data has been retrieved");			
			_photoVOs = new ArrayCollection(new Array());
			
			if(event.success){
				var photos:Array = event.data.photoSet.photos as Array;
				_numPhotos = photos.length;
				trace("_numPhotos: "+_numPhotos + " photos.length: "+photos.length);
				
				
				for(var i:int = 0; i < photos.length;i++){
					var vo:PhotoVO = new PhotoVO(photos[i]);
					vo.title = photos[i].title;
					vo.tags = photos[i].tags;
					_photoVOs.addItem(vo);
					
					trace(i);
					if(i >= _numPhotos-1){
						dispatchCustomDataEvent();
					}
				}
			}else{
				dispatchError();
			}
		}
		
		private function onGetPhotoStream(event:FlickrResultEvent):void{
			if(_service.hasEventListener(FlickrResultEvent.PHOTOS_SEARCH)){
				_service.removeEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream);
			}
			
			trace("an array of set data has been retrieved");			
			_photoVOs = new ArrayCollection(new Array());
			
			if(event.success){
				var photos:Array = event.data.photos.photos as Array;
				_numPhotos = photos.length;
				trace("_numPhotos: "+_numPhotos + " photos.length: "+photos.length);
				
				
				for(var i:int = 0; i < photos.length;i++){
					var vo:PhotoVO = new PhotoVO(photos[i]);
					_photoVOs.addItem(vo);
					
					trace(i);
					if(i >= _numPhotos-1){
						dispatchCustomDataEvent();
					}
				}
			}else{
				dispatchError();
			}
		}
		
		public function dispatchCustomDataEvent():void{
			trace("sq dispatchingCustomDataEvent");
			
			//_photoVOs.source.reverse();//to ensure photos on top of list in MultiplePhotosView get rendered first.
			
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(
				CustomDataEvent.PHOTOS_RETRIEVED_FROM_FLICKR,null,null,null,_photoVOs));
		}
		
		public function dispatchError():void{
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.ERROR_RETRIEVING_PHOTOS));
		}
	}
}