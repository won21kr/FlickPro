package com.squidzoo.eventSystem.events
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;

	public class CustomDataEvent extends Event
	{
		public static const GALLERY_IMAGE_SELECTED:String = "galleryImageSelected";
		public static const REMOVE_IMAGE_FROM_UPLOAD_LIST:String = "Remove image from upload list";
		public static const PHOTOS_RETRIEVED_FROM_FLICKR:String = "Photos retrieved from Flickr";
		public static const PRIVACY_SETTINGS:String = "privacy settings";

		private var _image:Bitmap;
		private var _fileReference:FileReference
		private var _string:String;
		private var _list:ArrayCollection;

		public function CustomDataEvent(type:String, file:FileReference, image:Bitmap = null, string:String=null, list:ArrayCollection=null, 
										bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);

			this._image = image;
			this._fileReference = file;
			this._string = string;
			this._list = list;
		}

		public function get list():ArrayCollection
		{
			return _list;
		}

		public function set list(value:ArrayCollection):void
		{
			_list = value;
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
			return new CustomDataEvent(type, fileReference, image, string, list, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("AndroidEvent","file","image","bubbles","cancelable");
		}
	}
}