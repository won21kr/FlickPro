package helpers
{
	import com.adobe.crypto.MD5;
	import com.adobe.utils.StringUtil;
	import com.adobe.webapis.flickr.AuthPerm;
	import com.adobe.webapis.flickr.ContentType;
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.SafetyLevel;
	import com.squidzoo.debug.DebugEvent;
	import com.squidzoo.eventSystem.EventCentral;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	//import ru.inspirit.net.MultipartURLLoader;
	//import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	public class Uploader extends EventDispatcher
	{
		private static const UPLOAD_DEST:String = "http://api.flickr.com/services/upload/";
		private var _service:FlickrService;

		public function Uploader(service:FlickrService):void{
			_service = service;
		}
		
		public function upload( fileReference:FileReference, 
								title:String,
								description:String,
								tags:String,
								is_public:Boolean,
								is_friend:Boolean,
								is_family:Boolean,
								safety_level:int = 0,
								content_type:int = 0,
								hidden:Boolean = false) : Boolean {
			
			//trace("service prereqs to upload: none should be null:");
			//trace("key :" +_service.api_key);
			//trace("secret key: "+_service.secret);
			//trace("token: "+_service.token);
			
			// Bail out if missing the necessary authentication parameters
			if (_service.api_key == "" || _service.secret == "" || _service.token == "") {
				return false;
			}
			
			// Bail out if application doesn't have authorisation to writ or delete from account
			if (_service.permission != AuthPerm.WRITE && _service.permission != AuthPerm.DELETE) {
				return false;
			}
			
			// The upload method requires signing, so go through
			// the signature process
			
			// Flash sends both the 'Filename' and the 'Upload' values
			// in the body of the POST request, so these are needed for the signature
			// as well, otherwise Flickr returns a error code 96 'invalid signature'
			var sig:String = StringUtil.trim( _service.secret );
			sig += "Filename" + fileReference.name;
			sig += "UploadSubmit Query"; //                         
			sig += "api_key" + StringUtil.trim( _service.api_key );
			sig += "auth_token" + StringUtil.trim( _service.token );                
			
			// optional values, in alphabetical order as required
			if ( content_type != ContentType.DEFAULT ) sig += "content_type" + content_type;
			if ( description != "" ) sig += "description" + description;
			if ( hidden ) sig += "hidden" + ( hidden ? 1 : 0 );
			sig += "is_family" + ( is_family ? 1 : 0 );
			sig += "is_friend" + ( is_friend ? 1 : 0 );
			sig += "is_public" + ( is_public ? 1 : 0 );
			if ( safety_level != SafetyLevel.DEFAULT ) sig += "safety_level" + safety_level;
			if ( tags != "" ) sig += "tags" + tags;
			if ( title != "" ) sig += "title" + title;
			
			var msg:String = sig;//"title: " +title+ " descriptipn: " +description+" tags: "+tags;
			EventCentral.getInstance().dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MESSAGE,msg)); 
			
			var vars:URLVariables = new URLVariables();
			vars.auth_token = StringUtil.trim( _service.token );
			vars.api_sig = MD5.hash( sig );
			vars.api_key = StringUtil.trim( _service.api_key );
			
			
			// optional values, in alphabetical order as required
			if ( content_type != ContentType.DEFAULT ) vars.content_type = content_type;
			if ( description != "" ) vars.description = description;
			if ( hidden ) sig += vars.hidden = ( hidden ? 1 : 0 );
			vars.is_family = ( is_family ? 1 : 0 );
			vars.is_friend = ( is_friend ? 1 : 0 );
			vars.is_public = ( is_public ? 1 : 0 );
			if ( safety_level != SafetyLevel.DEFAULT ) vars.safety_level = safety_level;
			if ( tags != "" ) vars.tags = tags;
			if ( title != "" ) vars.title = title;
		
			
			var request:URLRequest = new URLRequest( UPLOAD_DEST );
			request.data = vars;
			request.method = URLRequestMethod.POST;
			
			// Flickr expects the filename parameter to be named 'photo'
			fileReference.upload( request, "photo" );
		//	trace("fileReference.upload called");
			// Indicate that the upload process started
			return true;
		}
	}//end class
}//end package

		
//start upload that works except for privacy settings
		/*
		public function upload( fileReference:FileReference, 
								title:String = "",
								description:String = "",
								tags:String = "",
								is_public:Boolean = false,
								is_friend:Boolean = false,
								is_family:Boolean = false ) : void {
			// The upload method requires signing, so go through
			// the signature process
			
			// [OvD] Flash sends both the 'Filename' and the 'Upload' values
			// in the body of the POST request, so these are needed for the signature
			// as well, otherwise Flickr returns a error code 96 'invalid signature'
			
			var sig:String = StringUtil.trim( _service.secret );
			sig += "Filename" + fileReference.name;
			sig += "UploadSubmit Query"; //
			sig += "api_key" + StringUtil.trim( _service.api_key );
			sig += "auth_token" + StringUtil.trim( _service.token );
			
			// [OvD] optional values, the order is irrelevant
			if ( description != "" ) sig += "description" + description;
			if ( is_family ) sig += "is_family" + ( is_family ? 1 : 0 );
			if ( is_friend ) sig += "is_friend" + ( is_friend ? 1 : 0 );
			if ( is_public ) sig += "is_public" + ( is_public ? 1 : 0 );
			if ( tags != "" ) sig += "tags" + tags;
			if ( title != "" ) sig += "title" + title;
			
			var vars:URLVariables = new URLVariables();
			vars.auth_token = StringUtil.trim( _service.token );
			vars.api_sig = MD5.hash( sig );
			vars.api_key = StringUtil.trim(  _service.api_key );
			
			// [OvD] optional values, same order as the signature
			if ( description != "" ) vars.description = description;
			if ( is_family ) vars.is_family = ( is_family ? 1 : 0 );
			if ( is_friend ) vars.is_friend = ( is_friend ? 1 : 0 );
			if ( is_public ) vars.is_public = ( is_public ? 1 : 0 );
			if ( tags != "" ) vars.tags = tags;
			if ( title != "" ) vars.title = title;
			
			var request:URLRequest = new URLRequest( UPLOAD_DEST );
			request.data = vars;
			request.method = URLRequestMethod.POST;
			
			trace("2: upload: _is_public,_is_friend,_is_family: "+is_public,is_friend,is_family);
			
			// [OvD] Flickr expects the filename parameter to be named 'photo'
			fileReference.upload( request, "photo" );
		}//end upload(...)
		//end upload() that works except from privacy settings
		*/

		