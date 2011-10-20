package com.squidzoo.imageUtils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class ImageCache extends EventDispatcher{
		public static const IMAGE_DATA_ABSENT:int = 0;
		public static const IMAGE_DATA_PRESENT:int = 2;

		private static const _instance:ImageCache = new ImageCache();
		
		private var _bitmapDataRepository:Dictionary;
		
		public function ImageCache() {
			if(_instance != null) {
				throw new Error("This is a singleton class, use ImageCache.getInstance() " +
					"to get the singleton instance");
			}			
			
			_bitmapDataRepository = new Dictionary();
		}
		
		public static function getInstance():ImageCache {
			return _instance;
		}
		
		public function getImageData(imageId:String):Bitmap{
			var bitmapData:BitmapData;
			if(imageId != null) {
				bitmapData = _bitmapDataRepository[imageId]; 
			}
			return new Bitmap(bitmapData); 
		}
		
		public function putImageData(imageId:String, image:Bitmap):void {
			var imageData:BitmapData = image.bitmapData;
			if(imageId != null && imageData != null) {				
				_bitmapDataRepository[imageId] = imageData;
				
				//dispatchEvent(new ImageDataCacheEvent(ImageDataCacheEvent.IMAGE_DATA_ADDED, imageId));
			}
		}
		
		public function hasImageData(imageId:String):Boolean {
			if(imageId != null) {
				var bitmapData:BitmapData = _bitmapDataRepository[imageId];
				if(bitmapData != null) {
					return true;
				}
			}
			return false;
		}
		
		public function purgeImageData(imageId:String):void {
			if(imageId != null) {				
				var bitmapData:BitmapData = _bitmapDataRepository[imageId];
				if(bitmapData != null) {
					bitmapData.dispose();
				}
				delete _bitmapDataRepository[imageId];
			}
		}
		
		public function clear():void {
			var bitmapData:BitmapData;
			for(var key:Object in _bitmapDataRepository) {
				bitmapData = _bitmapDataRepository[key];
				if(bitmapData != null) {
					bitmapData.dispose();
				}
				delete _bitmapDataRepository[key];
				key = null;
			}			
		}
	}
}