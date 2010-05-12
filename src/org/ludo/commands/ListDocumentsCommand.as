/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: ListDocumentsCommand.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import org.ludo.delegates.DocumentDelegate;
	
	import org.ludo.controllers.ErrorController;
	
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class ListDocumentsCommand implements ICommand , IResponder
	{
		public function ListDocumentsCommand()
		{
		}
		public function execute(event : CairngormEvent) : void
		{
			var delegate : DocumentDelegate = new DocumentDelegate(this);
			delegate.listDocuments();
		}
		public function result(event : Object) : void
		{
		}
		public function fault(event : Object) : void
		{
			ErrorController.logErrorTwo("ListDocumentsCommand at fault: " + ObjectUtil.toString(event),"Command","ListDocumentsCommand");
			ErrorController.showErrorMeassage("ListDocumentsCommand at fault ");
		}
	}
}
