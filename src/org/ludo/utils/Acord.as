package org.ludo.utils
{
	import org.ludo.utils.LudoUtils;

	public class Acord
	{
		/*
		public function Acord()
		{
		}
		*/
		public static function getAcordTag(tagname:String):XML
		{
			return LudoUtils.dataStore.getFromXmlContainer("acordtags").acordtag.(@name == tagname)[0];
		}
	}
}