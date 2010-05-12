package org.ludo.models
{
	[Resource(name="users")]
  	[Bindable]
  	public class User extends BaseModel
	{
		public var login : String="";
		public var email : String="";
		public var first_name : String="";
		public var last_name : String="";		
		public var middle_name : String="";		
		public var status : String="";
		public var reset_password : String="";
		public var group : String="";
		public var agent_code : String="";
		[DateTime]
		public var effective_at : String="";
		[DateTime]
		public var expired_at : String="";
		[IgnoredBlank]
		public var password : String="";
		[IgnoredBlank]
		public var password_confirmation : String="";

		public function User(label:String="id")
		{
			super(label);
		}
	}
}
