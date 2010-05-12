package org.ludo.controllers
{
	import org.ludo.utils.LudoUtils;
   	public class DebugController {
		public static function debug(message:String):void {
			if(LudoUtils.navController.debugPanel!=null)
			{
				var _time:Date=new Date();
				LudoUtils.navController.debugPanel.addMessage("[" + _time.toString() + "] " + message);
			}
		}
    }
}