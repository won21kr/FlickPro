package com.squidzoo.statics
{
	public class LatestSearchTag
	{
		private static var _latestSearchTag:String = "Flickr";
		
		public function LatestSearchTag()
		{
		}
		
		public static function setLatestSearchTag(value:String):void{
			_latestSearchTag = value;
		}
		
		public static function getLatestSearchTag():String{
			return _latestSearchTag;
		}
	}
}