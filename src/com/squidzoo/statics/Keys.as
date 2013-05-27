package com.squidzoo.statics
{
	public class Keys
	{
		private static var _apiKey:String = 	"your key";;
		private static var _secretKey:String = 	"your secret key";
		
		public static function getApiKey():String{
			return _apiKey;
		}
		
		public static function getSecretKey():String{
			return _secretKey;
		}
	}
}