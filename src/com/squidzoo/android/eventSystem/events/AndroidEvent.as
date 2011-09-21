package com.squidzoo.android.eventSystem.events
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.FileReference;

	public class AndroidEvent extends Event
	{
		public static const GALLERY_IMAGE_SELECTED:String = "galleryImageSelected";

		private var _image:Bitmap;
		private var _fileReference:FileReference

		public function AndroidEvent(type:String, file:FileReference, image:Bitmap = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);

			this._image = image;
			this._fileReference = file;
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
			return new AndroidEvent(type, fileReference, image, bubbles,cancelable);
		}

		public override function toString():String
		{
			return formatToString("AndroidEvent","file","image","bubbles","cancelable");
		}
	}
}