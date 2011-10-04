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
	import com.squidzoo.eventSystem.events.CustomEvent;
	
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
				trace("_numPhotos: "+_numPhotos + " photos.length: "+photos.length);
				
				
				for(var i:int = 0; i < photos.length;i++){
					var vo:PhotoVO = new PhotoVO(photos[i]);
					_photoVOs.addItem(vo);
					
					trace(i);
					if(i >= _numPhotos-1){
						dispatchCustomDataEvent();
					}
				}
			}
		}

		public function dispatchCustomDataEvent():void{
			trace("sq dispatchingCustomDataEvent");
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(
				CustomDataEvent.PHOTOS_RETRIEVED_FROM_FLICKR,null,null,null,_photoVOs));
		}
		
		public function dispatchError():void{
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.ERROR_RETRIEVING_PHOTOS));
		}
		
	}
}