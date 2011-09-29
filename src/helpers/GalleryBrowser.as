package helpers
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
		//private var cameraRoll:CameraRoll;
		
		private var _fileRef:FileReference;
		
		private var loader:Loader;
		private var cameraRoll:CameraRoll;
		private var exifLoader:ExifLoader;
		private var mediaPromise:MediaPromise;
		
		public function GalleryBrowser()
		{
			
		}
		
		/*
		public function browse():void{
			if(_fileRef)_fileRef = null;
			
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
			//trace("_fileRef.name: "+_fileRef.name);
			
			//trace("file type: " + data.mediaType);
			//trace("file name: " + data.file.name);
			//trace("file url: " + data.file.url);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
			loader.load(new URLRequest(data.file.url));
		}
		
		*/
		
		
		
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
			//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 1"));
			
			var exif:ExifInfo = this.exifLoader.exif;
			
			if(!exif.ifds){
				trace("here");
				EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 1.5,Exif == null"));
			}
			
			//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 2"));
			
			var rotation:int = ExifUtils.getEyeOrientedAngle( exif.ifds );
			
			if(rotation == -1){
				onIOError();//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler -1"));
			}else{
				
			
				//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 3"));
				//i created a new bitmap, but otherwise, you could also make use of the line above and 
				//distor the image in your own way.
				var selectedImage:Bitmap = ExifUtils.getEyeOrientedBitmap( Bitmap( event.currentTarget.content ), exif.ifds );
				
				//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 4"));
				
				dispatchEvent(new CustomDataEvent(CustomDataEvent.GALLERY_IMAGE_SELECTED,_fileRef, selectedImage));
				
				//EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"contentLoadedHandler 5"));
			}
			/*
			if(selectedImage==null){
				EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,"image == null"));
			}
			*/
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
		
		/*
		private function onImageLoadComplete(e:Event):void{
			trace("onImageLoaded");
			var selectedImage:Bitmap = e.target.content as Bitmap;
			
			dispatchEvent(new CustomDataEvent(CustomDataEvent.GALLERY_IMAGE_SELECTED,_fileRef, selectedImage));
		}
		*/
	}
}







