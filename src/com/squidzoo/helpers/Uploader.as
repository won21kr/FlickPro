package com.squidzoo.helpers
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
	
	/**
	 * Broadcast as a result of the checkTickets method being called
	 *
	 * The event contains the following properties
	 *	success	- Boolean indicating if the call was successful or not
	 *	data - When success is true, contains an "uploadTickets" array of UploadTicket instances
	 *		   When success is false, contains an "error" FlickrError instance
	 *
	 * @see #checkTickets
	 * @see com.adobe.service.flickr.FlickrError
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	[Event(name="photosUploadCheckTickets", 
		 type="com.adobe.webapis.flickr.events.FlickrResultEvent")]
	
	/**
	 * Contains the methods for the Upload method group in the Flickr API.
	 * 
	 * Even though the events are listed here, they're really broadcast
	 * from the FlickrService instance itself to make using the service
	 * easier.
	 */
	
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
			return true;
		}
	}//end class
}//end package
		