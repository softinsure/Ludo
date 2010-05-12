package org.ludo.utils
{
	import flash.events.Event;
	
	import org.frest.Fr;

	public class XmlLoder
	{
		private var xmlstoloadConfigFile:String="xmlstores/config/initialxmlstoload.xml";
		private var xmlcount:int=0;
		private var loadedxmlcount:int=0;
		private var funcToBeCalledAfterLoad:Function; 
		private var functionArg:Array; 
		public function XmlLoder()
		{
		}

		public function setFuncToBeCalledAfterLoad(func:Function,argument:Array=null):void 
		{                                                                   
			this.funcToBeCalledAfterLoad=func;
			this.functionArg=argument;
     	}
	    public function loadXmlxByConfig(configFile:String) : void
		{
			if(configFile!="")
			{
				xmlstoloadConfigFile=configFile;
			}
			Fr.httpLoad(xmlstoloadConfigFile,parseConfig,null,"POST");
			//ServiceManager.load(xmlstoloadConfigFile,parseConfig ,"POST");
			//waitForLoad();
		}

		public function parseConfig(event:Event) : void
		{
			var xmlstoload:XMLList=XMLList(XML(event.target.data).xml);
			if(xmlstoload!=null)
			{
				xmlcount=xmlstoload.length();
				if(xmlcount>0)
				{
					for each (var xml:XML in xmlstoload)
					{
						loadXml(xml);
					}

				}			
			}
			else
			{
				loadedxmlcount++;
			}
		}
		private function loadXml(config:XML):void
		{
			//ServiceManager.load(config.@filepath,loadedXml,"POST",[config.@id]);
			Fr.httpLoad(config.@filepath,loadedXml,[config.@id],"POST");
		}
		private function loadedXml(event:Object,xmlid:String):void
		{
			//DebugMessage.debug(event.target.data.toString());
			LudoUtils.dataStore.addToXmlContainer(xmlid,XML(event.target.data));
			//DebugMessage.debug(LudoUtils.dataStore.getFromXmlContainer(xmlid).toString());
			loadedxmlcount++;
			//check if all loaded
			if(loadedxmlcount==xmlcount)
			{
				//call caller function
				if(funcToBeCalledAfterLoad!=null)
				{
					funcToBeCalledAfterLoad.apply(this,functionArg);
				}
			}
		}
	}
}
