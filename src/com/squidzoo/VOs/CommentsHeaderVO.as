package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class CommentsHeaderVO extends EventDispatcher
	{
		public var type:String="header";
		public var imageUrl:String;
		public var title:String;
	}
}