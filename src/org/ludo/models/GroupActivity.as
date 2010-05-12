package org.ludo.models
{
	[Resource(name="group_activities")]
  	[Bindable]
	public class GroupActivity extends BaseModel
	{
		public var activity_code : String;
		public var description : String;
		public var status : String;
		public var editable : String;
		public function GroupActivity(label:String="id")
		{
			super(label);
		}
	}
}