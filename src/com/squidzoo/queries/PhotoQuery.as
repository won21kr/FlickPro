package com.squidzoo.queries
{
	
	import com.squidzoo.VOs.DataObject;
	import com.squidzoo.VOs.PhotoVO;
	
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	import com.squidzoo.eventSystem.events.CustomEvent;
	
	import mx.collections.ArrayCollection;
	
	import com.squidzoo.statics.NSID;
	import com.squidzoo.statics.Service;
	import com.squidzoo.statics.ViewTypes;
	
	public class PhotoQuery
	{
		
		[Bindable]
		private var _service:FlickrService;
		private var _numPhotos:int;
		private var _photoVOs:ArrayCollection;
		private var _id:String;
		private var _tags:String;
		private var _setTitle:String;
		private var _setId:String;
		private var _pageIndex:int = 1;
		private var _numPages:int;
		
		public function PhotoQuery(){
		}
		
		public function getPage():int{
			return _pageIndex;
		}
		
		public function getNumPages():int{
			return _numPages;
		}
		
		public function setParams(dataObject:DataObject):void{
			if(dataObject.selectedSet){
				_id = dataObject.selectedSet.id;
				_setTitle = dataObject.selectedSet.title;
				_setId = dataObject.selectedSet.id;
			}
			if(dataObject.tags){
				_tags = dataObject.tags;
			}
			if(dataObject.pageIndex){
				_pageIndex = dataObject.pageIndex;
			}
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
					trace("pageIndex: "+_pageIndex);
					trace("get stream");
					_service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream); 
					_service.photos.search(NSID.getNSID(),
						"","any","",null,null,null,null,-1,"date-posted-desc",-1,"",
						-1,-1,-1,"","","","","","","",false,"","",-1,-1,"",10,_pageIndex);
					break;
				
				case ViewTypes.SEARCH_ALL_PUBLIC_PHOTOS_ON_FLICKR:
					_service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream); 
					_service.photos.search("",
						_tags,"","",null,null,null,null,-1,"date-posted-desc",-1,"",
						-1,-1,-1,"","","","","","","",false,"","",-1,-1,"",20,_pageIndex);
					break;
				
			}
		}
		
		private function onGetPhotoSet(event:FlickrResultEvent):void{
			if(_service.hasEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS)){
				_service.removeEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS,onGetPhotoSet);
			}
							
			_photoVOs = new ArrayCollection(new Array());
			
			if(event.success){	
				
				var photos:Array = event.data.photoSet.photos as Array;
				_numPhotos = photos.length;
				
				for(var i:int = 0; i < photos.length;i++){	
					var vo:PhotoVO = new PhotoVO(photos[i]);
					vo.title = photos[i].title;
					trace("pq: "+vo.title);
					
					if(_setTitle)vo.setTitle = _setTitle;
					if(_setId)vo.setId = _setId;
					
					_photoVOs.addItem(vo);
				
					createLinkedList();
					
					if(i >= _numPhotos-1){
						dispatchCustomDataEvent();
					}
				}
			}else{
				dispatchError();
			}
		}
		
		private function createLinkedList():void{
			for(var j:int = 0; j < _photoVOs.length-1; j++){
				_photoVOs[j].nextPhoto = _photoVOs[j+1];
			}
			
			for(var k:int = 1; k < _photoVOs.length; k++){
				_photoVOs[k].previousPhoto = _photoVOs[k-1];
			}
		}
		
		private function onGetPhotoStream(event:FlickrResultEvent):void{
			if(_service.hasEventListener(FlickrResultEvent.PHOTOS_SEARCH)){
				_service.removeEventListener(FlickrResultEvent.PHOTOS_SEARCH,onGetPhotoStream);
			}
			
			_numPages = event.data.photos.pages;
			
			_photoVOs = new ArrayCollection(new Array());
			
			if(event.success){
				var photos:Array = event.data.photos.photos as Array;
				_numPhotos = photos.length;
					
				for(var i:int = 0; i < photos.length;i++){
					var vo:PhotoVO = new PhotoVO(photos[i]);
					_photoVOs.addItem(vo);
					
					createLinkedList();
					
					if(i >= _numPhotos-1){
						dispatchCustomDataEvent();
					}
				}
			}else{
				dispatchError();
			}
		}
		
		private function dispatchCustomDataEvent():void{
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(
				CustomDataEvent.PHOTOS_RETRIEVED_FROM_FLICKR,null,null,null,_photoVOs));
		}
		
		private function dispatchError():void{
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.ERROR_RETRIEVING_PHOTOS));
		}
	}
}