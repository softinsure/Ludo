/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: LoadMainCommand.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.ludo.controllers.ErrorController;
	import org.ludo.utils.ConfigLoder;
	import org.ludo.utils.LudoUtils;
	
	public class LoadMainCommand implements ICommand
	{
		public function LoadMainCommand()
		{
		}

		public function execute(event : CairngormEvent) : void
		{
            //var xmlloader:XmlLoder=new XmlLoder();
            //xmlloader.setFuncToBeCalledAfterLoad(loadScreen);
           //xmlloader.loadXmlxByConfig("xmlstores/config/xmlstoload.xml");              
           	//xmlloader.waitForLoad();
			new ConfigLoder().loadXmlxByConfig("xmlstores/config/xmlstoload.xml",loadScreen);
        }

		public function loadScreen():void
		{
			LudoUtils.navController.appstack.selectedChild=LudoUtils.navController.mainContainer;
			LudoUtils.navController.appstack.visible=true;
			//LudoUtils.navController.mainContainer.loadMain();
		}
		public function fault(event : Object) : void
		{
			ErrorController.logErrorTwo("LoadMainCommand at fault: " + event.toString(),"Command","LoadMainCommand");
			ErrorController.showErrorMeassage("LoadMainCommand at fault: " + event);
		}
	}
}
