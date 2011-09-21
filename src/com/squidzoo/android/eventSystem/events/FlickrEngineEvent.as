package com.squidzoo.android.eventSystem.events {
	
	import flash.events.Event;
	
	public class FlickrEngineEvent extends Event{
		
		static public const ON_FROB_RECEIVED:String = "onOpenPopup";
		static public const ON_ERROR_GETTING_FROB:String = "onErrorGettingFrob";
		static public const ON_TOKEN_RECEIVED:String = "onConnected";
		static public const ON_ERROR_GETTING_TOKEN:String = "onErrorGettingToken";
		
		public var data:Object;
		
		public function FlickrEngineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
		}
		
		public function getName():String {
			return currentTarget.getName() ;
		}
	}
}