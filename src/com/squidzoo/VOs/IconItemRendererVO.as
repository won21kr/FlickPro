package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class IconItemRendererVO extends EventDispatcher
	{
		public var label:String;
		public var message:String;
		public var icon:String;
		
		public function IconItemRendererVO(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}