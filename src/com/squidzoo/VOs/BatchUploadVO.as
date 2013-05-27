package com.squidzoo.VOs
{
	import com.squidzoo.ItemRenderers.BatchUploadItemRenderer;
	
	import com.squidzoo.debug.DebugEvent;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	

	[Bindable]
	public class BatchUploadVO extends EventDispatcher {
		
		public static const UPLOAD_NOT_STARTED:String = "Upload not started";
		public static const UPLOAD_HAS_STARTED:String = "Upload has started";
		public static const UPLOAD_IN_PROGRESS:String = "Upload in progress";
		public static const UPLOAD_COMPLETE:String = "Upload complete";
		
	
		private var _bytesInFile:int;
		private var _bytesLoaded:int;
		//have to be public so itemrenderer can read them
		public var file:FileReference;
		public var fileName:String;
		public var image:Bitmap;
		public var uploadStatus:String = UPLOAD_NOT_STARTED;
		public var uploadPercentage:int = 0;
		public var thumbnail:Bitmap;
		private var _imageWidth:int = 180;
		private var forCompiler:BatchUploadVO;//required
		public var ir:BatchUploadItemRenderer = new BatchUploadItemRenderer();
	
		
		public function BatchUploadVO(file:FileReference, image:Bitmap){
			this.file = file;
			
			this._bytesInFile = file.size;
			this.image = image;
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onUploadDataComplete);
			file.addEventListener(ProgressEvent.PROGRESS,onProgressEvent);
			uploadStatus = UPLOAD_NOT_STARTED;
		}
		
		private function onProgressEvent(event:ProgressEvent):void{
			_bytesLoaded = event.bytesLoaded;
			uploadStatus = UPLOAD_IN_PROGRESS;
			uploadPercentage = (_bytesLoaded/_bytesInFile)*100;
			ir.update(uploadPercentage);			
		}
		
		private function onUploadDataComplete(event:DataEvent):void{
			
			var root:XML = new XML(event.data);
			var id:String = root.photoid.children()[0];
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,id));
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.ADD_UPLOADED_PHOTO_TO_SET,null,null,id));
			uploadStatus = UPLOAD_COMPLETE;	
		}
		
		private function scaleBitmapData(_bmd:BitmapData, 
										 targetContainerWidth:Number, targetContainerHeight:Number=0):Bitmap { 
			//set matrix sx & sy 
			var sx:Number = targetContainerWidth / _bmd.width; 
			var sy:Number = 0;
			
			if(targetContainerHeight==0){
				sy = sx;			
				targetContainerHeight = _bmd.height * sy;
				
			}else{
				sy = targetContainerHeight / _bmd.height; 				
			}
			
			//instantiate new matrix, and set scaling 
			var m:Matrix = new Matrix(); 
			m.scale(sx, sy); 
			
			//create new bitmapdata	
			var newBmd:BitmapData = new BitmapData(targetContainerWidth, targetContainerHeight); 
			//draw new bitmapdata with matrix	
			newBmd.draw(_bmd, m); 
			//create final bitmap with new bitmapdata 
			var newBmp:Bitmap = new Bitmap(newBmd); 
			//set smooting to true 
			newBmp.smoothing = true; 
			
			return newBmp; 
		}
				
	}
}