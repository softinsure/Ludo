package org.ludo.models
{
	[Resource(name="agents")]
  	[Bindable]
	public class Agent extends BaseModel
	{
		public var agent_code : String;
		public var agency_code : String;
		public var first_name : String;
		public var middle_name : String;
		public var last_name : String;
		public var address : String;
		public var address2 : String;
		public var city : String;
		public var state : String;
		public var zip : String;
		public var email : String;
		public var work_phone : String;
		public var cell_phone : String;
		public var ssn : String;
		public var license_number : String;
		public var license_type : String;
		public function Agent(label:String="id")
		{
			super(label);
		}
	}
}