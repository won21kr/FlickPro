package com.squidzoo.android.eventSystem.events
{
	import flash.events.Event;

	public class CustomEvent extends Event {
		
		public static const ACTIONBAR_MENU_ICON_CLICKED_BROWSE_SETS:String = "Browse sets";
		public static const ACTIONBAR_MENU_ICON_CLICKED_UPLOAD:String = "Upload";
		
		public function CustomEvent(type:String):void {
			super(type);
		}
	}
}