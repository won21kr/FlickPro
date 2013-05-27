package com.squidzoo.helpers
{
	import com.flexnroses.mobile.utils.hardware.ExifUtils;
	import com.squidzoo.debug.DebugEvent;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	
	import mx.events.FlexEvent;
	
	public class GalleryBrowser extends Sprite
	{
		private var _fileRef:FileReference;
		
		private var loader:Loader;
		private var cameraRoll:CameraRoll;
		private var exifLoader:ExifLoader;
		private var mediaPromise:MediaPromise;
		
		public function GalleryBrowser()
		{
			
		}
		
		//1. instantiate CameraRoll and get its event handlers ready
		public function browse():void
		{
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"browse"));
			
			if( CameraRoll.supportsBrowseForImage )
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, contentLoadedHandler );
				
				cameraRoll = new CameraRoll();
				cameraRoll.addEventListener( MediaEvent.SELECT, mediaSelectHandler );
				cameraRoll.addEventListener( Event.CANCEL, errorHandler );
				cameraRoll.browseForImage();
			}
			else
			{
				trace("Unable to access Camera Roll");
				EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"unable to access Camera Roll"));
			}	
		}
		
		//2. once CameraRoll is browsed and an image selected, find its Exif data
		private function mediaSelectHandler( event:MediaEvent ):void
		{   
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"mediaSelectHandler"));
			mediaPromise = event.data;
			trace(mediaPromise.file.url);
			_fileRef = mediaPromise.file;
			
			this.exifLoader = new ExifLoader();
			this.exifLoader.addEventListener(Event.COMPLETE, completeHandler );
			this.exifLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.exifLoader.load( new URLRequest( mediaPromise.file.url ) );
		}
		
		private function errorHandler( event:Event ):void
		{
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"ErrorHanlder"));
		}
		
		//3. once Exif data is available, use loader to obviously load mediaPromised found in step 2
		private function completeHandler( event:Event ):void
		{
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"completeHandler"));
			loader.unload();
			loader.loadFilePromise( mediaPromise );
		}
		
		//4. use exif data and access ExifUtils to get the image found appear eye oriented.
		private function contentLoadedHandler( event:Event ):void
		{
			var exif:ExifInfo = this.exifLoader.exif;
			
			if(!exif.ifds){
				trace("here");
				EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 1.5,Exif == null"));
			}
			
			var rotation:int = ExifUtils.getEyeOrientedAngle( exif.ifds );
			
			if(rotation == -1){
				onIOError();
			}else{
				
				var selectedImage:Bitmap = ExifUtils.getEyeOrientedBitmap( Bitmap( event.currentTarget.content ), exif.ifds );
				
				dispatchEvent(new CustomDataEvent(CustomDataEvent.GALLERY_IMAGE_SELECTED,_fileRef, selectedImage));
				
			}
		}
		
		//if exifLoader fails, use standard Loader
		protected function onIOError(event:IOErrorEvent=null):void
		{
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"onIOError"));
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
			loader.load(new URLRequest(mediaPromise.file.url));
		}
		
		//listen for standard loader event completion
		protected function onImageLoadComplete(event:Event):void
		{
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"onImageLoadComplete"));
			var selectedImage:Bitmap = event.target.content as Bitmap;
			dispatchEvent(new CustomDataEvent(CustomDataEvent.GALLERY_IMAGE_SELECTED,_fileRef, selectedImage));
		}
		
	}
}







