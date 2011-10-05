package com.squidzoo.eventSystem.events
{
	import flash.events.Event;

	public class CustomEvent extends Event {
		
		public static const ACTIONBAR_MENU_ICON_CLICKED_BROWSE_SETS:String = "Browse sets";
		public static const ACTIONBAR_MENU_ICON_CLICKED_UPLOAD:String = "Upload";
		public static const ACTIONBAR_MENU_ICON_CLICKED_PHOTOSTREAM:String = "Photostream";
		public static const ACTIONBAR_MENU_ICON_CLICKED_SEARCH:String = "Search";
		public static const ERROR_RETRIEVING_PHOTOS:String = "Error retrieving photos";
		public static const INVALIDATE_DISPLAY_LIST:String = "Invalidate display list";
		
		public function CustomEvent(type:String):void {
			super(type);
		}
	}
}