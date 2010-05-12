package org.ludo.models
{
	[Resource(name="group_permissions")]
  	[Bindable]
	public class GroupPermission extends BaseModel
	{
		public var group_code : String;
		public var activity_code : String;
		public var lob_code : String;
		public var status : String;
		public var editable : String;
		public function GroupPermission(label:String="id")
		{
			super(label);
		}
		public function save():void
		{
			id==0?create():update();
		}
	}
}