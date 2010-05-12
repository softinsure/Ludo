package org.ludo.objects
{
	public class PageProperties extends Object
	{
		public var pageid:String="";
		public var description:String="";
		public var readOnly:Boolean=false;
		public var rateDependant:Boolean=false;
		public var requiredToBind:Boolean=false;
		public var properties:XML;
		public function PageProperties(pageid:String)
		{
			super();
		}
		public function get processMode():String
		{
			return readOnly?"V":"E";
		}
	}
}