package org.ludo.models
{
	[Resource(name="agencies")]
  	[Bindable]
	public class Agency extends BaseModel
	{
		public var contact_title : String;
		public var name : String;
		public var contact_first_name : String;
		public var contact_middle_name : String;
		public var contact_last_name : String;
		public var address : String;
		public var address2 : String;
		public var city : String;
		public var state : String;
		public var zip : String;
		public var contact_email : String;
		public var contact_phone1 : String;
		public var contact_phone2 : String;
		public var agency_code : String;
		public var fax : String;
		public var license_number : String;
		public var license_type : String;
		//public var agency_code : String;
		public function Agency(label:String="id")
		{
			super(label);
		}
	}
}