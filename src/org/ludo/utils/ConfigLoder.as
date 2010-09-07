package org.ludo.utils
{
	import org.frest.utils.FrUtils;

	public class ConfigLoder
	{
		private var xmlstoloadConfigFile:String="xmlstores/config/initialxmlstoload.xml";
		private var funcToBeCalledAfterLoad:Function; 
		private var functionArg:Array; 
		public function ConfigLoder()
		{
		}
	    public function loadXmlxByConfig(configFile:String,afterLoadFunction:Function=null,funcArgument:Array=null):void
		{
			this.funcToBeCalledAfterLoad=afterLoadFunction;
			this.functionArg=funcArgument;
			if(configFile!="")
			{
				xmlstoloadConfigFile=configFile;
			}
			LudoUtils.modelController.configFileReader.file_path=configFile;
			LudoUtils.modelController.configFileReader.afterAction=parseConfig;
			LudoUtils.modelController.configFileReader.action("configloader");
		}

		public function parseConfig(event:Object,model:Object) : void
		{
			var configFiles:XMLList=XML(event.result).children();
			if(configFiles!=null)
			{
				if(configFiles.length()>0)
				{
					for each (var xml:XML in configFiles)
					{
						loadConfig(xml);
					}

				}			
			}
			if(funcToBeCalledAfterLoad!=null)
			{
				funcToBeCalledAfterLoad.apply(null,functionArg);
			}
		}
		private function loadConfig(config:XML):void
		{
			LudoUtils.dataStore.addToXmlContainer(config["fileid"],XML(FrUtils.base64EDecodeString(config["content"])));
		}
	}
}
