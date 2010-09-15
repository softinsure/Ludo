package org.ludo.models
{
	[Resource(name="billing_infos")]
	[Bindable]
	public class BillingInfo extends BaseModel
	{
		public var policy_header_id:int;
		public var payment_plan:String;
		public var billing_type:String;
		public var billing_status:String;
		public var quoted_pemium:Number=0.00;
		public var current_amt_due:Number=0.00;
		public var total_amt_due:Number=0.00;
		public var next_amt_due:Number=0.00;
		public var installments_remaining:int=0;
		public var installments_billed:int=0;
		public var total_billed:Number=0.00;
		public var last_amt_paid:Number=0.00;
		public var total_amt_paid:Number=0.00;
		public var last_invoice_amt:Number=0.00;
		public var prior_balance:Number=0.00;
		[DateTime]
		public var current_due_dt:String;
		[DateTime]
		public var next_due_dt:String;
		[DateTime]
		public var next_bill_dt:String;
		[DateTime]
		public var last_bill_dt:String;
		[DateTime]
		public var last_invoice_dt:String;
		public var address1:String;
		public var address2:String;
		public var state:String;
		public var city:String;
		public var zip:String;
		public var notes:String;
		[Base64]
		[Xml]
		public var payment_schedule : XML;
		[Ignored]
		[BelongsTo]
		public var policyHeader:PolicyHeader;
		
		public function BillingInfo(label:String="id")
		{
			super(label);
		}
	}
}