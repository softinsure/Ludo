package org.ludo.models
{
	[Resource(name="groups")]
  	[Bindable]
	public class Group extends BaseModel
	{
		public var group_code : String;
		public var description : String;
		public var status : String;
		public var editable : String;
		public function Group(label:String="id")
		{
			super(label);
		}
	}
}