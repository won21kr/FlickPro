package com.squidzoo.Utils
{
	public class UniqueStringUtil
	{
		public function UniqueStringUtil()
		{
		}
		
		public static function getTimeStamp():String{
			var now:Date = new Date();
			return now.valueOf().toString();
		}
	}
}