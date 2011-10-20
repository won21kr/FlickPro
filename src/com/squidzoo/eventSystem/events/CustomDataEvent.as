
package com.squidzoo.eventSystem.events
{
	import VOs.PhotoVO;
	import VOs.SetVO;
	import VOs.SettingsVO;
	import VOs.TagVO;
	
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
		public static const SET_SELECTED_IN_SET_LIST:String = "Set selected in upload settings";
		public static const ADD_UPLOADED_PHOTO_TO_SET:String = "Add uploaded photo to set";
		public static const FIRST_PHOTO_ID:String = "First photo id";
		public static const FIRST_PHOTO_RETRIEVAL_ERROR:String = "First photo retrieval error";
		public static const SET_FROM_SET_SELECTION_VIEW:String = "Set From Set Selection View";
		public static const NEW_PHOTO_TITLE_SAVED_TO_FLICKR:String = "New photo title saved to Flickr";
		public static const NEW_PHOTO_DESCRIPTION_SAVED_TO_FLICKR:String = "New photo description saved to Flickr";
		public static const NEW_TAG_SAVED_TO_FLICKR:String = "New Tag description saved to Flickr";
		public static const TAG_CLICKED:String = "Tag clicked";
		public static const TAG_REMOVED:String = "Tag removed";
		public static const VISIBILITY_CHANGED:String = "visibility changed";
		
		private var _image:Bitmap;
		private var _fileReference:FileReference
		private var _string:String;
		private var _list:ArrayCollection;
		private var _photoVO:PhotoVO;
		private var _settingsVO:SettingsVO;
		private var _amount:int;
		private var _setVO:SetVO;
		private var _tagVO:TagVO;

		public function CustomDataEvent(type:String, file:FileReference=null, image:Bitmap = null, string:String=null, list:ArrayCollection=null,photoVO:PhotoVO=null, 
										settingsVO:SettingsVO=null, amount:int = 0, setVO:SetVO=null, tagVO:TagVO=null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);

			this._image = image;
			this._fileReference = file;
			this._string = string;
			this._list = list;
			this._photoVO = photoVO;
			this._settingsVO = settingsVO;
			this._amount = amount;
			this._setVO = setVO;
			this._tagVO = tagVO;
		}

		public function get tagVO():TagVO
		{
			return _tagVO;
		}

		public function set tagVO(value:TagVO):void
		{
			_tagVO = value;
		}

		public function get setVO():SetVO
		{
			return _setVO;
		}

		public function set setVO(value:SetVO):void
		{
			_setVO = value;
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
			return new CustomDataEvent(type, fileReference, image, string, list, photoVO, settingsVO, amount, setVO, tagVO, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("AndroidEvent","file","image","bubbles","cancelable");
		}
	}
}