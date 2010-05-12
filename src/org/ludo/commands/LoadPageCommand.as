/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: LoadPageCommand.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.ludo.utils.ConfigLoder;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.XmlLoder;

	public class LoadPageCommand implements ICommand
	{
		public function LoadPageCommand()
		{
		}
		public function execute(event : CairngormEvent) : void
		{
			//loading page needs transaction
			if(LudoUtils.transController.hasTransaction)
        	{
        		var xmlstoload:String=LudoUtils.transController.getProperty("xmlstoloadconfig");
        		if(xmlstoload!="" && LudoUtils.transController.transactionChanged)//if LOB changed
        		{
					new ConfigLoder().loadXmlxByConfig(xmlstoload,freshBuild);
		            //var xmlloader:XmlLoder=new XmlLoder();
		            //xmlloader.setFuncToBeCalledAfterLoad(freshBuild);
		            //xmlloader.loadXmlxByConfig(xmlstoload);         			
		        }
		        else
		        {
		        	freshBuild();
		        }
     		}
     		else
     		{
     			throw new Error("No transaction information available.");
		    }		
		}

		private function freshBuild():void
		{
			LudoUtils.pageController.resetPage();
			LudoUtils.pageController.resetPageID();
			LudoUtils.pageController.clearPage();
			LudoUtils.pageController.initializePage();
			var acordroot:String=LudoUtils.transController.getProperty("acordroot");
			if(acordroot!="")
			{
				LudoUtils.modelController.setxmlMapper(acordroot);
			}
			LudoUtils.formBuilder.initialize();
			LudoUtils.formBuilder.PaintPage();
			LudoUtils.navController.selectTopMenuIndex(LudoUtils.transController.defaultTopMenuIndex);
			LudoUtils.navController.selectLeftMenuIndex(LudoUtils.transController.defaultLeftMenuIndex);
		}
		public function fault(event : Object) : void
		{
			//smartquote.debug("LoadPageCommand#fault: " + event);
		}
	}
}
