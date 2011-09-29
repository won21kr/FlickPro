package statics
{
	public class NSID
	{
		private static var _nsid:String;
		
		public function NSID()
		{
		}
		
		public static function getNSID():String{
			return _nsid;
		}
		
		public static function setNSID(value:String):void{
			_nsid = value;
		}
	}
}