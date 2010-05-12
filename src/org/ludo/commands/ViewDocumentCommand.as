/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: ViewDocumentCommand.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.commands
{
	import org.ludo.delegates.DocumentDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.buttonBarClasses.*;
	import mx.rpc.IResponder;
	
	
	import org.ludo.models.Document;
	
	import org.ludo.utils.LudoUtils;

	public class ViewDocumentCommand implements ICommand , IResponder
	{
		public function ViewDocumentCommand()
		{
		}

		public function execute(event : CairngormEvent) : void
		{
			var delegate : DocumentDelegate = new DocumentDelegate(this);
			delegate.viewDocument(event.data);
		}

		public function result(event : Object) : void
		{
			LudoUtils.modelController.document = Document.fromBase64XML(event.result);
		}
		public function fault(event : Object) : void
		{
		}
	}
}
