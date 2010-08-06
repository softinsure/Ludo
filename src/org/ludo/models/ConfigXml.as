package org.ludo.models
{
	import org.ludo.utils.LudoUtils;

	[Resource(name="config_xmls")]
  	[Bindable]
	public class ConfigXml extends BaseModel
	{
		public var name : String;
		public var config_type : String;
		public var used_for : String;
		public var active : String;
		public var version : int=0;
		public var xmlstring : String;
		public function ConfigXml(label:String="id")
		{
			super(label);
		}
	}
}