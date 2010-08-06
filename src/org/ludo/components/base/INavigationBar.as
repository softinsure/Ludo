/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: INavigationBar.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.base
{
	import mx.events.CloseEvent;

	public interface INavigationBar
	{
		//function get menutype():String
		function set nextPage(value:String):void
		function get nextPage():String
		function set currentTransaction(value:String):void
		function get currentTransaction():String
		function set lastSelect(idx:int):void
		function get lastSelect():int
		function set currSelect(idx:int):void
		function get currSelect():int
		function set confirmchange(value:Boolean):void
		function get confirmchange():Boolean
		function set container(value:String):void
		function get container():String
		function refreshNavigation():void
 		function enableItem(idx:int,enable:Boolean):void
		function selectMenuByPageId(pageid:String):void
		function getMenuIndexByPageId(pageid:String):int
		function set selectItem(idx:int):void
		function selectFirstItem():void
		function selectNextItem():void
		function confirmBeforeChangeContainer(event:CloseEvent):void
		function confirmBeforeChangePage(event:CloseEvent):void
		function setConfirmChange(confirmchange:String):void
		function changeContainer():void
		function changePage():void
		function noChangePage():void
		function getPageIDIfAny(idx:int):String
		function getItemObject(idx:int):Object
	}
}