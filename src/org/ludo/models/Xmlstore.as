package org.ludo.models
{
	[Resource(name="xmlstores")]
  	[Bindable]
  	public class Xmlstore extends BaseModel
	{
		[Base64]
		[Xml]
		public var xmlstring : XML;
		[Base64]
		[Xml]
		public var original_xml : XML;
		[Base64]
		[Xml]
		public var menu_xml : XML;
		[Base64]
		[Xml]
		public var payment_schedule : XML;
		[Base64]
		[Xml]
		public var change_detail : XML;
		//public var quote_id : int;
 
    	//[BelongsTo]
    	//public var quote:Quote;
    	
    	public function Xmlstore(label:String="id")
		{
			super(label);
		}
	}
}