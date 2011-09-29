package com.squidzoo.eventSystem.events
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.FileReference;

	public class CustomDataEvent extends Event
	{
		public static const GALLERY_IMAGE_SELECTED:String = "galleryImageSelected";
		public static const REMOVE_IMAGE_FROM_UPLOAD_LIST:String = "Remove image from upload list";

		private var _image:Bitmap;
		private var _fileReference:FileReference
		private var _string:String;

		public function CustomDataEvent(type:String, file:FileReference, image:Bitmap = null, string:String=null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);

			this._image = image;
			this._fileReference = file;
			this._string = string;
		}

		public function get string():String
		{
			return _string;
		}

		public function set string(value:String):void
		{
			_string = value;
		}

		public function get fileReference():FileReference
		{
			return _fileReference;
		}

		public function get image():Bitmap
		{
			return _image;
		}

		public override function clone():Event
		{
			return new CustomDataEvent(type, fileReference, image, string, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("AndroidEvent","file","image","bubbles","cancelable");
		}
	}
}