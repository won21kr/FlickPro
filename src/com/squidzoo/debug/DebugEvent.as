package com.squidzoo.debug
{
	import flash.events.Event;
	
	public class DebugEvent extends Event
	{
		public static const DEBUG_MESSAGE:String = "Debug message";
		public var message:String;
		public function DebugEvent(type:String, inMessage:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			message = inMessage;
		}
	}
}