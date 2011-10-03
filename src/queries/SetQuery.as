package queries
{
	import Interfaces.IPhotoQuery;
	
	import VOs.DataObject;
	import VOs.PhotoVO;
	import VOs.SetVO;
	
	import com.adobe.fileformats.vcard.Phone;
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
	
	public class SetQuery implements IPhotoQuery
	{
		[Bindable]
		private var _service:FlickrService;
		private var _numPhotos:int;
		private var _photoVOs:ArrayCollection;
		private var _id:String;
		
		public function SetQuery(){
		}
		
		public function setParams(dataObject:DataObject):void{
			_id = dataObject.selectedSet.id;
			trace("SetQuery.set params: _id :"+_id);
		}

		public function execute():void{
			_photoVOs = new ArrayCollection();
			_service = Service.getService();
			trace("id in execute: "+_id);
			_service.photosets.getPhotos(_id); 
			_service.addEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS, onGetPhotos);  
		}
		
		private function onGetPhotos(event:FlickrResultEvent):void{
			_service.removeEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS,onGetPhotos);
			trace("an array of set data has been retrieved");
			
			_photoVOs = new ArrayCollection(new Array());
			if(event.success){
				var photos:Array = event.data.photoSet.photos as Array;
				_numPhotos = photos.length;
				trace("_numPhotos");
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
			}else{
				trace("error - no photos retrieved");
			}
		}
		
		private function onEventComplete(event:Event):void{
			var image:Bitmap = event.currentTarget.content;
			var vo:PhotoVO = new PhotoVO();
			vo.smallImage = image;
			_photoVOs.addItem(vo);
			
			//if(_photoVOs.length > _numPhotos-1){
				dispatchCustomDataEvent();
			//}
		}

		public function dispatchCustomDataEvent():void{
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(
				CustomDataEvent.PHOTOS_RETRIEVED_FROM_FLICKR,null,null,null,_photoVOs));
		}
		
	}
}