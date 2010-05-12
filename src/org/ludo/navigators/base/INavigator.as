package org.ludo.navigators.base
{
	public interface INavigator
	{
	        function generateNavigationByXml(xml:XML):void
	        function selectMenuIndex(idx:int,menuid:String=""):void
	        function enableItem(idx:int,menuid:String=""):void
	        function disableItem(idx:int,menuid:String=""):void
	}
}