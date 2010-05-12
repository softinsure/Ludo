package org.ludo.connectors
{
	import mx.controls.Alert;
	
	import org.ludo.utils.LudoUtils;
	
	public class ImageConnector
	{
		public static function getImageByName(imageName:String):Class
        {
			return LudoUtils.referencedMethods.callMethod("getimage",imageName);
       }
    }
}