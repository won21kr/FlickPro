package statics
{
	public class Keys
	{
		private static var _apiKey:String = 	"b58e71edb891f7404d7b75add98b5f7b";;
		private static var _secretKey:String = 	"854232f4bc051c84";
		
		public static function getApiKey():String{
			return _apiKey;
		}
		
		public static function getSecretKey():String{
			return _secretKey;
		}
	}
}