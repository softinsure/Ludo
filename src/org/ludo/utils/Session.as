package org.ludo.utils
{

	public class Session
	{
		public static function setSesson(key:String,value:*) : void
		{
			LudoUtils.dataStore.setSession(key,value);
		}
		public static function getSession(key:String) : *
		{
			return LudoUtils.dataStore.getSession(key);
		}
		public static function clear():void
		{
			LudoUtils.dataStore.emptysSession();
		}
	}
}