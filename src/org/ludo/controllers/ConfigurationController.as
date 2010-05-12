package org.ludo.controllers
{
	import org.ludo.utils.LudoUtils;

	 public class ConfigurationController
	 {
	 	private var configfile:XML;
	 	private static var configurationManager:ConfigurationController;
        public static function getInstance():ConfigurationController
        {
            if (configurationManager == null)
            {
                configurationManager = new ConfigurationController();
            }
            return configurationManager;
        }
        public function ConfigurationController()
		{
			if (configurationManager != null)
			{
                throw new Error("Only one ConfigurationManager instance may be instantiated.");
            }
        }
        public function configvalue(key:String):String
        {
        	if(configfile==null)
        	{
        		configfile=XML(LudoUtils.dataStore.getFromXmlContainer("configuration"));
        	}
        	return configfile.key.(@id==key).@value;
        }
     }
}