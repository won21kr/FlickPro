package VOs
{
	import flash.display.Bitmap;

	[Bindable]
	public class PhotoSizeVO
	{
		public var image:Bitmap;
		public var id:String;
		public var type:String = "PhotoSizeVO";
		
		public function PhotoSizeVO()
		{
		}
	}
}