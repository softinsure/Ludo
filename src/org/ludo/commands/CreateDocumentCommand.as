/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: CreateDocumentCommand.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import org.ludo.delegates.DocumentDelegate;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public class CreateDocumentCommand implements ICommand , IResponder
	{
		private var onComplete:Function;
		
		public function CreateDocumentCommand()
		{
		}

		public function execute(event:CairngormEvent) : void
		{
			var delegate:DocumentDelegate = new DocumentDelegate(this);
			if(event.data is Array)
			{
				//check second param for store save
				var arrayData:Array=event.data as Array;
				if(arrayData.length>1)
				{
					if(arrayData[1] is Function)
					{
						onComplete=arrayData[1];
					}
				}
				//first one is quote
				delegate.createDocument(arrayData[0]);
			}
			else
			{
				delegate.createDocument(event.data);
			}
		}

		public function result(event : Object) : void
		{
			onComplete.call(this);
			//Function(e){onComplete.call(this)};
		}

		public function fault(event : Object) : void
		{
			//ErrorHandle.logErrorTwo("CreateDocumentCommand at fault: " + event.toString(),"Command","CreateDocumentCommand");
			//ErrorHandler.showErrorMeassage("CreateDocumentCommand at fault: " + event);
		}
	}
}
