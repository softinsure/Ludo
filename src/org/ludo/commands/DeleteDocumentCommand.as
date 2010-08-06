/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: DeleteDocumentCommand.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import org.ludo.delegates.DocumentDelegate;
	import org.ludo.controllers.EventNames;
	
	import org.ludo.models.Document;
	
	import mx.controls.buttonBarClasses.*;
	import mx.rpc.IResponder;
	public class DeleteDocumentCommand implements ICommand , IResponder
	{
		public function DeleteDocumentCommand()
		{
		}

		public function execute(event : CairngormEvent) : void
		{
			var delegate : DocumentDelegate = new DocumentDelegate(this);
			delegate.deleteDocument(event.data);
		}
		public function result(event : Object) : void
		{
		}
		public function fault(event : Object) : void
		{
		}
	}
}
