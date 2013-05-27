package com.squidzoo.VOs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class GetMoreVO extends EventDispatcher
	{
		public var getMoreLabel:String;
		
		public function GetMoreVO(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}