package VOs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class SizeVO extends EventDispatcher
	{
		public var height:int;
		public var width:int;
		public var url:String;
		public var source:String;
		public var label:String;
		public var dimensions:String = width + " x " + height;
		
		public function SizeVO(target:IEventDispatcher=null)
		{
			
			super(target);
		}
	}
}