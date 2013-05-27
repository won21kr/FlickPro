package com.squidzoo.statics
{
	public class Frob
	{
		private static var _frob:String;
		
		public function Frob()
		{
		}
		
		public static function getFrob():String{
			return _frob;
		}
		
		public static function setFrob(value:String):void{
			_frob = value;
		}
	}
}