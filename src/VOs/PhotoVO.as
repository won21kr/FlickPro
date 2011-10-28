package VOs
{
	import com.adobe.utils.ArrayUtil;
	import com.adobe.utils.StringUtil;
	import com.adobe.webapis.flickr.FlickrError;
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.Photo;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.chewtinfoil.utils.StringUtils;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	import com.squidzoo.eventSystem.events.CustomEvent;
	import com.squidzoo.imageUtils.ImageCache;
	import com.squidzoo.imageUtils.ImageUtils;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ArrayUtil;
	
	import skins.TagIRSkin;
	
	import statics.Service;

	[Bindable]
	public class PhotoVO extends EventDispatcher
	{
		public var image:Bitmap;
		public var service:FlickrService;
		public var photo:Photo;
		public var title:String;
		public var tags:ArrayCollection = new ArrayCollection();
		public var description:String;
		public var ownerName:String;
		public var isFavorite:Boolean;
		public var isFamily:Boolean;
		public var isFriend:Boolean;
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
		
		
		private var _newTitle:String;
		
		private var _loader:Loader;
	
		private var _newDescription:String;
		private var _newTag:String;
		
		private var _idToBeRemoved:String = "";
		
		public var privacySetting:String;
		private var _isFamilyPreferredValue:Boolean;
		private var _isFriendPreferredValue:Boolean;
		private var _isPublicPreferredValue:Boolean;

		public var truncatedTitle:String;
		public var truncatedDateTaken:String;
		
		public function PhotoVO(photo:Photo)
		{
			//trace("photoVO constructor");
			_service = Service.getService();
			
			_cache = ImageCache.getInstance();
		
			this.id = photo.id;
			this.photo = photo;
			this.title = photo.title;
			this.truncatedTitle = StringUtils.truncate(title,30);
			//trace("photoVO: "+title, id);
			this.description = photo.description;
			
			
			imageURL = buildSmallImageURL();
			largeImageString = buildLargeImageURL();	
			
			if(_cache.hasImageData(imageURL)){
				//trace("is cached");
				displayImage(_cache.getImageData(imageURL));
			}else{
				//trace("is not chached");
				load();
			}
		}
		
		public function setNewTitle(newTitle:String):void{
			if(newTitle){
				_newTitle = newTitle;
				_service.addEventListener(FlickrResultEvent.PHOTOS_SET_META,onSetTitle);
				_service.photos.setMeta(this.id,_newTitle,this.description);
			}
		}
		
		public function setNewDescription(newDescription:String):void{
			if(newDescription){
				_newDescription = newDescription;
				_service.addEventListener(FlickrResultEvent.PHOTOS_SET_META,onSetDescription);
				_service.photos.setMeta(this.id,this.title,_newDescription);
			}
		}
		
		public function removeTag(id:String):void{
			if(id){
				_idToBeRemoved = id;
				_service.addEventListener(FlickrResultEvent.PHOTOS_REMOVE_TAG,onRemoveTag);
				_service.photos.removeTag(id);
			}
		}
		
		public function addNewTag(newTag:String):void
		{
			if(newTag && newTag!= ""){
				_newTag = newTag;
				_service.addEventListener(FlickrResultEvent.PHOTOS_SET_TAGS,onSetTags);
				
				var allTags:String = "";
				
				for(var i:int = 0; i < tags.length; i++){
					allTags += tags[i].name + ",";
				}
				allTags += _newTag;
				
				_service.photos.setTags(this.id,allTags);
			}
		}
		
		public function setVisibility(isPublic:Boolean,isFriend:Boolean,isFamily:Boolean,permComment:int,permAddmeta:int):void{
			_isFamilyPreferredValue = isFamily;
			_isFriendPreferredValue = isFriend;
			_isPublicPreferredValue = isPublic;
			_service.addEventListener(FlickrResultEvent.PHOTOS_SET_PERMS, onSetPerms);
			_service.photos.setPerms(id, isPublic,isFriend,isFamily,permComment,permAddmeta);
		}
		
		protected function onRemoveTag(event:Event):void
		{
			for(var i:int = 0;i < tags.length;i++){			
				if(tags[i].id == _idToBeRemoved){
					tags.removeItemAt(i);
				}
			}
			
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.TAG_REMOVED));
		}
		
		private function onSetPerms(event:Event):void
		{
			isFamily  = _isFamilyPreferredValue;
			isFriend = _isFriendPreferredValue;
			isPublic = _isPublicPreferredValue;
			
			if(isFamily){
				privacySetting = "Family"
			}else if(isFriend){
				privacySetting = "Friend"
			}else{
				privacySetting = "Public"
			}
			
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.VISIBILITY_CHANGED));
			
		}
		
		protected function onSetTags(event:Event):void
		{
			//var tagVO:TagVO = new TagVO();
			//tagVO.name = _newTag;
			//tags.addItem(tagVO);
			_newTag = "";
			loadMeta();
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.NEW_TAG_SAVED_TO_FLICKR));
		}
		
		private function onSetDescription(event:Event):void
		{
			this.description = _newDescription;
			_newDescription = "";
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.NEW_PHOTO_DESCRIPTION_SAVED_TO_FLICKR,null,null,id));
			// TODO Auto-generated method stub
		}
		
		private function onSetTitle(event:FlickrResultEvent):void
		{
			this.title = _newTitle;
			_newTitle = "";
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.NEW_PHOTO_TITLE_SAVED_TO_FLICKR,null,null,id));
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
			_loader = new Loader();
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onEventComplete);
			_loader.load(request);
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.INVALIDATE_DISPLAY_LIST));
		}
		
		private function onEventComplete(event:Event):void{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onEventComplete);
			var image:Bitmap = event.currentTarget.content;
			
			if(_cache.hasImageData(imageURL)==false){
				_cache.putImageData(imageURL,image);
			}
			
			
			displayImage(image);
		}
		
		private function displayImage(image:Bitmap):void{
			trace("photoVO: displayImage(): "+title, id);
			image = ImageUtils.scaleToTargetHeight(image,100);
			this.image = image;
			loadMeta();
			EventCentral.getInstance().dispatchEvent(new CustomEvent(CustomEvent.INVALIDATE_DISPLAY_LIST));
		}
		
		private function loadMeta():void{
			trace("photoVO: loadMeta(): "+title, id);
			_service.addEventListener(FlickrResultEvent.PHOTOS_GET_INFO,onGetMeta);
			//_service.addEventListener(FlickrError.SERVICE_CURRENTLY_UNAVAILABLE,onServiceNotAvailable);
			_service.photos.getInfo(id);
		}
		
		protected function onGetMeta(event:FlickrResultEvent):void
		{
			//trace("onGetMeta Id rec" +event.data.photo.id + " ID in vo " +id);
			//_service.removeEventListener(FlickrResultEvent.PHOTOS_GET_INFO,onGetMeta);
			if(event.data.photo.id == id){
				if(event.success && event.data && event.data.photo){
					
					if(event.data.photo.dateTaken) {
						dateTaken = event.data.photo.dateTaken;
						truncatedDateTaken = StringUtils.truncate(dateTaken,22,"");
					}
					if(event.data.photo.description) description = event.data.photo.description;
					if(event.data.photo.isFamily) isFamily = event.data.photo.isFamily;
					if(event.data.photo.isFavorite) isFavorite = event.data.photo.isFriend;
					if(event.data.photo.isPublic) isPublic = event.data.photo.isPublic
					if(event.data.photo.ownerName) ownerName = event.data.photo.ownerName;
					
					if(event.data.photo.tags){
						tags.removeAll();
						var a:Array = event.data.photo.tags;
						for(var i:int = 0;i < a.length; i++){
							var tagVO:TagVO = new TagVO();
							tagVO.name = a[i].tag;
							tagVO.id = a[i].id;
							trace("photo vo: tagVO name:"+tagVO.name);
							tags.addItem(tagVO);
						}
					}
					
					if(isFamily){
						privacySetting = "Family";
					}else if(isFriend){
						privacySetting = "Friends"; 
					}else{
						privacySetting = "Public";
					}
					
					//if(event.data.photo.title) title = event.data.photo.title;
				}
			}
		}
		
		
	}
}