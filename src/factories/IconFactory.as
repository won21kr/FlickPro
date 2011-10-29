package factories
{
	import mx.collections.Sort;

	[Bindable]
	public class IconFactory
	{	
		import flash.display.Bitmap;

		public static const ADD_ICON:String = "AddIcon";
		[Embed(source="assets/images/buttonIcons40x40/AddIconGreyLP.png")]
		private static var AddIcon:Class;
		
		public static const ARROW_UP_ICON:String = "ArrowUpIcon";
		[Embed(source="assets/images/buttonIcons40x40/arrowUpLP.png")]
		private static var ArrowUp:Class;
		
		public static const ARROW_DOWN_ICON:String = "ArrowDownIcon";
		[Embed(source="assets/images/buttonIcons40x40/arrowDownLP.png")]
		private static var ArrowDown:Class;
		
		public static const CLOUD_ICON:String = "CloudIcon";
		[Embed(source="assets/images/buttonIcons40x40/cloudLP.png")]
		private static var CloudIcon:Class;
		
		public static const EDIT_ICON:String = "EditIcon";
		[Embed(source="assets/images/buttonIcons40x40/EditIconGreyLP.png")]
		private static var EditIcon:Class;
		
		public static const FULL_SCREEN_ICON:String = "FullScreen";
		[Embed(source="assets/images/buttonIcons40x40/FullScreenIconGreyLP.png")]
		private static var FullScreenIcon:Class;
		
		public static const GRID_ICON:String = "GridIcon";
		[Embed(source="assets/images/buttonIcons40x40/SetViewByGridLP.png")]
		private static var GridIcon:Class;
		
		public static const IMAGE_ICON:String = "ImageIcon";
		[Embed(source="assets/images/buttonIcons40x40/imageLP.png")]	
		private static var ImageIcon:Class;
		
		public static const QUESTION_ICON:String = "QuestionIcon";
		[Embed(source="assets/images/buttonIcons40x40/questionMarkLP.png")]
		private static var QuestionIcon:Class;
		
		public static const REMOVE_ICON:String = "RemoveIcon";
		[Embed(source="assets/images/buttonIcons40x40/RemoveIconGreyLP.png")]
		private static var RemoveIcon:Class;
		
		public static const SAVE_ICON:String = "SaveIcon";
		[Embed(source="assets/images/buttonIcons40x40/SaveIconGreyLP.png")]
		private static var SaveIcon:Class;
		
		public static const SET_ICON:String = "SetIcon";
		[Embed(source="assets/images/buttonIcons40x40/SetLP.png")]
		private static var SetIcon:Class;
		
		public static const SHRINK_ICON:String = "ShrinkIcon";
		[Embed(source="assets/images/buttonIcons40x40/shrinkLP.png")]
		private static var ShrinkIcon:Class;
		
		public static const SORT_BY_ALPHA:String = "SortAlpha";
		[Embed(source="assets/images/buttonIcons40x40/SortAlphaLP.png")]
		private static var SortAlpha:Class;
		
		public static const SORT_BY_TIME:String = "SortTime";
		[Embed(source="assets/images/buttonIcons40x40/SortByTimeLP.png")]
		private static var SortTime:Class;
		
		public static const VERT_LIST_ICON:String = "VertListIcon";
		[Embed(source="assets/images/buttonIcons40x40/SetViewByLineLP.png")]
		private static var VertListIcon:Class;

		private static var bmp:Bitmap = new Bitmap();
	
		public static function getIcon(name:String):Bitmap{
			
			switch(name){			
				case IconFactory.ADD_ICON:
					return new AddIcon();
					break;
				
				case IconFactory.ARROW_UP_ICON:
					return new ArrowUp();
					break;
				
				case IconFactory.ARROW_DOWN_ICON:
					return new ArrowDown();
					break;
				
				case IconFactory.CLOUD_ICON:
					return new CloudIcon();
					break;
				
				case IconFactory.EDIT_ICON:
					return new EditIcon();
					break;
				
				case IconFactory.FULL_SCREEN_ICON:
					return new FullScreenIcon();
					break;
				
				case IconFactory.GRID_ICON:
					return new GridIcon();
					break;
				
				case IconFactory.IMAGE_ICON:
					return new ImageIcon();
					break;
				
				case IconFactory.QUESTION_ICON:
					return new QuestionIcon();
					break;
				
				case IconFactory.REMOVE_ICON:
					return new RemoveIcon();
					break;
				
				case IconFactory.SAVE_ICON:
					return new SaveIcon();
					break;
				
				case IconFactory.SET_ICON:
					return new SetIcon();
					break;
				
				case IconFactory.SHRINK_ICON:
					return new ShrinkIcon();
					break;
				
				case IconFactory.SORT_BY_ALPHA:
					return new SortAlpha();
					break;
				
				case IconFactory.SORT_BY_TIME:
					return new SortTime();
					break;
				
				case IconFactory.VERT_LIST_ICON:
					return new VertListIcon();
					break;
				
				default:
				return bmp;	
			}
		}
		
		public static function getIconString(name:String):String{
			
			switch(name){			
				case IconFactory.EDIT_ICON:
					return "@Embed('assets/images/buttonIcons40x40/EditIconGreyLP.png')";
					break;
				
				case IconFactory.VERT_LIST_ICON:
					return "@Embed('assets/images/buttonIcons40x40/SetViewByLineLP.png')";
					break;
				
				case IconFactory.GRID_ICON:
					return "@Embed('assets/images/buttonIcons40x40/SetViewByGridLP.png')";
					break;
				
				case IconFactory.REMOVE_ICON:
					return "@Embed('assets/images/buttonIcons40x40/RemoveIconGreyLP.png')";
					break;
				
				case IconFactory.QUESTION_ICON:
					return "@Embed('assets/images/buttonIcons40x40/questionMarkLP.png')"
					break;
				
				default:
					return "";	
			}
		}
	
	}
}