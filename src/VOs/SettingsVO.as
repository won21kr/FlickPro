package VOs
{
	public class SettingsVO
	{
		public var title:String;
		public var description:String;
		public var tags:String;
		public var is_family:Boolean = true;
		public var is_public:Boolean = false;
		public var is_friend:Boolean = false;
		
		public function SettingsVO()
		{
			trace("settingsvo constr");
		}
	}
}