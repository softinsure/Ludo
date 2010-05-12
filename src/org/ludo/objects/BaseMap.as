package org.ludo.objects
{
	import flash.display.DisplayObject;

	public class BaseMap extends Object
	{
		public var displayObject:DisplayObject;
		public var fieldmap:String="";
		public var fieldaction:String="save";
		public var fieldtype:String="";
		public var description:String="";
		public var defaultvalue:String="";
		public function BaseMap()
		{
			super();
		}
	}
}