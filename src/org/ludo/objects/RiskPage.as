package org.ludo.objects
{
	public class RiskPage extends Object
	{
		public var pageid:String="";
		public var risktype:String="";
		public var description:String="";
		public var unitnumner:String="";
		public var risk:String="";
		public function RiskPage(type:String="MISSING")
		{
			risktype=type;
			super();
		}
		public function get xmlNode():XML
		{
			return <RiskPage><ID>{pageid}</ID><Description>{description}</Description><Unit>{unitnumner}</Unit><Risk>{risk}</Risk><Type>{risktype}</Type></RiskPage>;
		}
	}
}