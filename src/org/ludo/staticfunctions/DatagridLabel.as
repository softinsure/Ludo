package org.ludo.staticfunctions
{
	import org.common.utils.XFormatter;
	
	//only static functions available
	public class DatagridLabel
	{
		public static function dateLabel(label:String,data:Object,datafield:String):String 
		{
			return XFormatter.formatDateString(label);
		}

	}
}