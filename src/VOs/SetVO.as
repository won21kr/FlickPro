package VOs
{
	import com.adobe.webapis.flickr.FlickrService;
	
	import spark.components.View;

	[Bindable]
	public class SetVO
	{
		public var forCompiler:SetVO;
		
		public var title:String;
		
		public var id:String;
		
		public var nextView:View;
		
		public var service:FlickrService;
		
		public function SetVO()
		{
		}
	}
}