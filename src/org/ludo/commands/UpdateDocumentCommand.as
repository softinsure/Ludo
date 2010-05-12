/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: DocumentDelegate.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.commands
{
	import org.ludo.delegates.DocumentDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	import org.ludo.controllers.ErrorController;

	public class UpdateDocumentCommand implements ICommand , IResponder
	{
		private var updateXmlStore:Boolean=false;
		public function UpdateDocumentCommand()
		{
		}

		public function execute(event : CairngormEvent) : void
		{
			var delegate:DocumentDelegate = new DocumentDelegate(this);
			delegate.updateDocument(event.data);
		}

		public function result(event : Object) : void
		{
		}
		public function fault(event : Object) : void
		{
			ErrorController.logErrorTwo("UpdateDocumentCommand at fault: " + ObjectUtil.toString(event),"Command","UpdateDocumentCommand");
			ErrorController.showErrorMeassage("UpdateDocumentCommand at fault ");			
		}
	}
}