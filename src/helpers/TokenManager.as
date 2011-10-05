package helpers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import spark.managers.PersistenceManager;
	
	public class TokenManager extends EventDispatcher
	{
		public function TokenManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function setToken(value:String):void{
			trace("TokenManager.set Token()");
			
			var p:PersistenceManager = new PersistenceManager();
			var obj:Object = new Object();
			obj.data = value;
			obj.isValid = "true";
			trace("obj.data: "+obj.data);
			
			p.setProperty("apiToken", obj);
			
		}
		
		public static function getToken():String{
			
			var p:PersistenceManager = new PersistenceManager();
			var obj:Object = p.getProperty("apiToken");
			
			if(obj){
				return obj.data;
			}else{
				return null;
			}
		}
		
		public static function isValid():Boolean{
			var p:PersistenceManager = new PersistenceManager();
			var obj:Object = p.getProperty("apiToken");
			
			if(obj){
				return true;
			}else{
				return false;
			}	
		}
		
	}
}