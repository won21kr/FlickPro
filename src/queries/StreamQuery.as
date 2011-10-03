package queries
{
	import Interfaces.IPhotoQuery;
	
	import VOs.DataObject;
	import VOs.PhotoVO;
	
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	import statics.NSID;
	import statics.Service;
	
	public class StreamQuery implements IPhotoQuery
	{
		[Bindable]
		private var _service:FlickrService;
		private var _numPhotos:int;
		private var _photoVOs:ArrayCollection;
		private var _id:String;
		
		public function StreamQuery(){
		}
		
		public function setParams(dataObject:DataObject):void{

		}
		
		

		public function execute():void{
			_photoVOs = new ArrayCollection();
			_service = Service.getService();
			_service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH,onPhotoSearchResult); 
			_service.photos.search(NSID.getNSID(),
				"","any","",null,null,null,null,-1,"date-posted-desc",-1,"",
				-1,-1,-1,"","","","","","","",false,"","",-1,-1,"",50);
		}
		
		private function onPhotoSearchResult(event:FlickrResultEvent):void{
			_service.removeEventListener(FlickrResultEvent.PHOTOS_SEARCH,onPhotoSearchResult);
			trace("an array of set data has been retrieved");
			if(_photoVOs)_photoVOs.removeAll();
			_photoVOs = new ArrayCollection(new Array());
			
			var photos:Array = event.data.photos.photos as Array;
			_numPhotos = photos.length;
			for(var i:int = 0; i < photos.length;i++){
				var imageURL:String = 	'http://static.flickr.com/' + 
					photos[i].server + '/' + 
					photos[i].id + '_' +
					photos[i].secret + '_m.jpg';
				var request:URLRequest = new URLRequest(imageURL);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onEventComplete);
				loader.load(request);
			}
		}
		
		private function onEventComplete(event:Event):void{
			trace("PhotostreamQuery.onEventComplete()");
			var image:Bitmap = event.currentTarget.content;
			var vo:PhotoVO = new PhotoVO();
			vo.smallImage = image;
			_photoVOs.addItem(vo);
			//trace("_photoVOs.length: "+_photoVOs.length, "_numPhotos"+_numPhotos);
			if(_photoVOs.length > _numPhotos-1){
				dispatchCustomDataEvent();
			}
		}
		
		public function dispatchCustomDataEvent():void{
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(
				CustomDataEvent.PHOTOS_RETRIEVED_FROM_FLICKR,null,null,null,_photoVOs));
		}
	}
}