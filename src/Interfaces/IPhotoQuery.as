package Interfaces
{
	import VOs.DataObject;
	
	import mx.collections.ArrayCollection;
	
	public interface IPhotoQuery
	{
		function execute():void;
		function setParams(dataObject:DataObject):void;
		function dispatchCustomDataEvent():void;
	}
	
}