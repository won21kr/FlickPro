package com.squidzoo.android.flickr
{
	import com.squidzoo.android.eventSystem.events.AndroidEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MediaEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	public class GalleryBrowser extends Sprite
	{
		private var cameraRoll:CameraRoll;
		private var _fileRef:FileReference;
		
		public function GalleryBrowser()
		{
		
		}
		
		public function browse():void{
			if (CameraRoll.supportsBrowseForImage){
				cameraRoll = new CameraRoll();
				cameraRoll.addEventListener(MediaEvent.SELECT, onImageSelected);
				cameraRoll.browseForImage();
			}
		}
		
		private function onImageSelected(e:MediaEvent):void 
		{
			cameraRoll.removeEventListener(MediaEvent.SELECT,onImageSelected);
			var data:MediaPromise = e.data;
			_fileRef = data.file;
			trace("_fileRef.name: "+_fileRef.name);
			
			trace("file type: " + data.mediaType);
			trace("file name: " + data.file.name);
			trace("file url: " + data.file.url);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
			loader.load(new URLRequest(data.file.url));
		}
		
		private function onImageLoadComplete(e:Event):void{
			trace("onImageLoaded");
			var selectedImage:Bitmap = e.target.content as Bitmap;
			dispatchEvent(new AndroidEvent(AndroidEvent.GALLERY_IMAGE_SELECTED,_fileRef, selectedImage));
		}
	}
}







