package com.squidzoo.android.flickr.VOs
{
	import com.adobe.webapis.flickr.FlickrService;
	
	import spark.components.View;

	public class SetVO
	{
		[Bindable]
		public var title:String;
		
		[Bindable]
		public var id:String;
		
		[Bindable]
		public var nextView:View;
		
		[Bindable]
		public var service:FlickrService;
		
		public function SetVO()
		{
		}
	}
}