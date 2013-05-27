package com.squidzoo.helpers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import spark.managers.PersistenceManager;
	
	public class NSIDManager extends EventDispatcher
	{
		public function NSIDManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function setNSID(value:String):void{
			
			var p:PersistenceManager = new PersistenceManager();
			var obj:Object = new Object();
			obj.data = value;
			obj.isValid = "true";
			
			p.setProperty("apiNSID", obj);
			
		}
		
		public static function getNSID():String{
			
			var p:PersistenceManager = new PersistenceManager();
			var obj:Object = p.getProperty("apiNSID");
			
			if(obj){
				return obj.data;
			}else{
				return null;
			}
		}
		
		public static function isValid():Boolean{
			var p:PersistenceManager = new PersistenceManager();
			var obj:Object = p.getProperty("apiNSID");
			
			if(obj){
				return true;
			}else{
				return false;
			}	
		}
		
	}
}