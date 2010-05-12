package org.ludo.models
{
	[Resource(name="payments")]
  	[Bindable]
  	public class Payment extends BaseModel
	{
		public var payment_plan : String;
		public var down_payment_type : String;
		public var bill_type : String;
		public var min_down:Number=0.00;
		public var installment:Number=0.00;
		public var total_charge:Number=0.00;
		public var agency_fee:Number=0.00;
		public var policy_fee:Number=0.00;
		public var misc_fee:Number=0.00;
		public var misc_fee_reason : String;
		public var quote_id : int;
    	public function Payment(label:String="id")
		{
			super(label);
		}
	}
}