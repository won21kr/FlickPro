package factories
{
	import flash.display.Bitmap;
	
	import mx.collections.ArrayCollection;

	public class HelpFactory
	{
		//BrowseSetsView
		public static var BROWSE_SETS:String = "Browse Sets";
		private static var _browseSetsAC:ArrayCollection;
		
		private static var browseSets_description_sortAlphabetically:String = "Sort sets alphabetically";
		private static var browseSets_description_sortByTime:String = "Sort sets by time - with newest first";
		private static var browseSets_description_addSet:String = "Create a new set in your Flickr account";
		private static var browseSets_description_removeSet:String = "Delete set from your Flickr account. Doesn't delete images from photostream.";

		//MultiplePhotosView's SetState
		public static var VIEW_SINGLE_SET:String = "View single set";
		private static var _viewSingleSetAC:ArrayCollection;
		
		private static var multiplePhotosView_setState_description_list:String = "Show images in list";
		private static var multiplePhotosView_setState_description_grid:String = "Show images in grid";
		private static var multiplePhotosView_setState_description_edit:String = "Edit set details";
		private static var multiplePhotosView_setState_description_removeSet:String = "Delete set from your Flickr account. Doesn't delete images from photostream.";
		
		//MultiplePhotosView's StreamState
		public static var VIEW_PHOTOSTREAM:String = "View photostream";
		private static var _viewPhotostreamAC:ArrayCollection;
		private static var multiplePhotosView_StreamState_description_list:String = "Show images in list";
		private static var multiplePhotosView_StreamsState_description_grid:String = "Show images in grid";
		private static var multiplePhotosView_StreamState_description_next:String = "next 20";
		private static var multiplePhotosView_StreamState_description_previous:String = "previous 20";
		
		//Upload
		public static var UPLOAD:String = "Upload";
		private static var _uploadAC:ArrayCollection;
		private static var upload_pick_image:String = "Add image from Gallery to upload list. Add more images by clicking again";
		private static var upload_edit_settings:String = "Decide title, description, tags and visibility for all images in upload list";
		private static var upload_pick_set:String = "Choose set, or create a new set";
		private static var upload_batchUpload:String = "Batch upload all images in upload list";
		
		public function HelpFactory()
		{
		}
		
		public static function getHelpContent(value:String):ArrayCollection{
			
			switch(value){
				case BROWSE_SETS:
					if(_browseSetsAC==null){
						
						_browseSetsAC = new ArrayCollection();
						_browseSetsAC.addItem(buildObject(browseSets_description_sortAlphabetically,IconFactory.getIcon(IconFactory.SORT_BY_ALPHA)));
						_browseSetsAC.addItem(buildObject(browseSets_description_sortByTime,IconFactory.getIcon(IconFactory.SORT_BY_TIME)));
						_browseSetsAC.addItem(buildObject(browseSets_description_addSet,IconFactory.getIcon(IconFactory.ADD_ICON)));
						_browseSetsAC.addItem(buildObject(browseSets_description_removeSet,IconFactory.getIcon(IconFactory.REMOVE_ICON)));
						
						return _browseSetsAC;
					}else{
						return _browseSetsAC;
					}
				break;
				
				case VIEW_SINGLE_SET:
					if(_viewSingleSetAC==null){
						_viewSingleSetAC = new ArrayCollection();
						
						_viewSingleSetAC.addItem(buildObject(multiplePhotosView_setState_description_list,IconFactory.getIcon(IconFactory.VERT_LIST_ICON)));
						_viewSingleSetAC.addItem(buildObject(multiplePhotosView_setState_description_grid,IconFactory.getIcon(IconFactory.GRID_ICON)));
						_viewSingleSetAC.addItem(buildObject(multiplePhotosView_setState_description_edit,IconFactory.getIcon(IconFactory.EDIT_ICON)));
						_viewSingleSetAC.addItem(buildObject(multiplePhotosView_setState_description_removeSet,IconFactory.getIcon(IconFactory.REMOVE_ICON)));
						
						return _viewSingleSetAC;
					}else{
						return _viewSingleSetAC;
					}
					break;
				case VIEW_PHOTOSTREAM:
					if(_viewPhotostreamAC==null){
						_viewPhotostreamAC = new ArrayCollection();
						_viewPhotostreamAC.addItem(buildObject(multiplePhotosView_StreamState_description_list,IconFactory.getIcon(IconFactory.VERT_LIST_ICON)));
						_viewPhotostreamAC.addItem(buildObject(multiplePhotosView_StreamsState_description_grid,IconFactory.getIcon(IconFactory.GRID_ICON)));
						_viewPhotostreamAC.addItem(buildObject(multiplePhotosView_StreamState_description_next,IconFactory.getIcon(IconFactory.ARROW_DOWN_ICON)));
						_viewPhotostreamAC.addItem(buildObject(multiplePhotosView_StreamState_description_previous,IconFactory.getIcon(IconFactory.ARROW_UP_ICON)));
						
						return _viewPhotostreamAC;
					}else{
						return _viewPhotostreamAC;
					}
					break;
				
				case UPLOAD:
						if(_uploadAC==null){
							_uploadAC = new ArrayCollection();
							_uploadAC.addItem(buildObject(upload_pick_image,IconFactory.getIcon(IconFactory.IMAGE_ICON)));
							_uploadAC.addItem(buildObject(upload_edit_settings,IconFactory.getIcon(IconFactory.EDIT_ICON)));
							_uploadAC.addItem(buildObject(upload_pick_set, IconFactory.getIcon(IconFactory.SET_ICON)));
							_uploadAC.addItem(buildObject(upload_batchUpload, IconFactory.getIcon(IconFactory.CLOUD_ICON)));
							
							return _uploadAC;
						}else{
							return _uploadAC;
						}
					break;	
				
				default:
					return null;
					break;
			}//end switch
			
			return _browseSetsAC;
		}

		private static function buildObject(description:String,icon:Bitmap):Object{
			var object:Object = new Object();
			object.description = description;
			object.icon = icon;
			return object;
		}
	}
}