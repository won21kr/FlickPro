package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import spark.components.Image;
	
	[Bindable]
	public class IconItemRendererWithImageVO extends EventDispatcher
	{
		public var largeImageString:String;
		
		public function IconItemRendererWithImageVO(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}