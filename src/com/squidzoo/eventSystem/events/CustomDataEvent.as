package com.squidzoo.eventSystem.events
{
	import VOs.PhotoVO;
	import VOs.SettingsVO;
	
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
		public static const IMAGE_IN_LIST_CLICKED:String = "image in list clicked";
		public static const SETTINGS_SELECTED:String = "Settings selected";
		public static const UPLOAD_PROGRESS:String = "upload progress";

		private var _image:Bitmap;
		private var _fileReference:FileReference
		private var _string:String;
		private var _list:ArrayCollection;
		private var _photoVO:PhotoVO;
		private var _settingsVO:SettingsVO;
		private var _amount:int;

		public function CustomDataEvent(type:String, file:FileReference, image:Bitmap = null, string:String=null, list:ArrayCollection=null,photoVO:PhotoVO=null, 
										settingsVO:SettingsVO=null, amount:int = 0, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);

			this._image = image;
			this._fileReference = file;
			this._string = string;
			this._list = list;
			this._photoVO = photoVO;
			this._settingsVO = settingsVO;
			this._amount = amount;
		}

		public function get amount():int
		{
			return _amount;
		}

		public function set amount(value:int):void
		{
			_amount = value;
		}

		public function get settingsVO():SettingsVO
		{
			return _settingsVO;
		}

		public function set settingsVO(value:SettingsVO):void
		{
			_settingsVO = value;
		}

		public function get photoVO():PhotoVO
		{
			return _photoVO;
		}

		public function set photoVO(value:PhotoVO):void
		{
			_photoVO = value;
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
			return new CustomDataEvent(type, fileReference, image, string, list, photoVO, settingsVO, amount, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("AndroidEvent","file","image","bubbles","cancelable");
		}
	}
}