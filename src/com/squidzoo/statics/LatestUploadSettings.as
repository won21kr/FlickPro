package com.squidzoo.statics
{
	public class LatestUploadSettings
	{
		private static var _title:String;
		private static var _description:String;
		private static var _tags:String;
		private static var _photoSet:String;
		private static var _isPublic:Boolean;
		private static var _isFriend:Boolean;
		private static var _isFamily:Boolean;
		
		public function LatestUploadSettings()
		{
		}

		
		public static function get isFamily():Boolean
		{
			return _isFamily;
		}

		public static function set isFamily(value:Boolean):void
		{
			_isFamily = value;
		}

		public static function get isFriend():Boolean
		{
			return _isFriend;
		}

		public static function set isFriend(value:Boolean):void
		{
			_isFriend = value;
		}

		public static function get isPublic():Boolean
		{
			return _isPublic;
		}

		public static function set isPublic(value:Boolean):void
		{
			_isPublic = value;
		}

		public static function get photoSet():String
		{
			return _photoSet;
		}

		public static function set photoSet(value:String):void
		{
			_photoSet = value;
		}

		public static function get tags():String
		{
			return _tags;
		}

		public static function set tags(value:String):void
		{
			_tags = value;
		}

		public static function get description():String
		{
			return _description;
		}

		public static function set description(value:String):void
		{
			_description = value;
		}

		public static function get title():String
		{
			return _title;
		}

		public static function set title(value:String):void
		{
			_title = value;
		}

	}
}