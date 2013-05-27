package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class CommentVO extends EventDispatcher
	{
		public var type:String = "comment";
		public var authorname:String;
		public var body:String;
		public var createdTime:String;
		
	}
}