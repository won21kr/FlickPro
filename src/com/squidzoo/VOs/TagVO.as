package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class TagVO extends EventDispatcher
	{
		public var name:String;
		public var id:String;
		
		public function TagVO(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}