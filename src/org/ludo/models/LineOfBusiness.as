package org.ludo.models
{
	[Resource(name="line_of_businesses")]
  	[Bindable]
	public class LineOfBusiness extends BaseModel
	{
		public var lob_code : String;
		public var description : String;
		public var status : String;
		public var editable : String;
		public function LineOfBusiness(label:String="id")
		{
			super(label);
		}
	}
}