package org.ludo.models
{
	[Resource(name="payment_plans")]
  	[Bindable]
	public class PaymentPlan extends BaseModel
	{
		public var lob : String;
		public var plan_code : String;
		public var plan_term : int;
		public var plan_desc : String;
		public var installment_number : int=0;
		public var installment_fee : Number=0.00;
		public var policy_fee : Number=0.00;
		public var down_payment : Number=0.00;
		public var down_payment_days : int=0;
		public var first_percent : Number=0.00;
		public var first_days : int=0;
		public var second_percent : Number=0.00;
		public var second_days : int=0;
		public var third_percent : Number=0.00;
		public var third_days : int=0;
		public var fourth_percent : Number=0.00;
		public var fourth_days : int=0;
		public var fifth_percent : Number=0.00;
		public var fifth_days : int=0;
		public var sixth_percent : Number=0.00;
		public var sixth_days : int=0;
		public var seventh_percent : Number=0.00;
		public var seventh_days : int=0;
		public var eighth_percent : Number=0.00;
		public var eighth_days : int=0;
		public var ninth_percent : Number=0.00;
		public var ninth_days : int=0;
		public var tenth_percent : Number=0.00;
		public var tenth_days : int=0;
		public var eleventh_percent : Number=0.00;
		public var eleventh_days : int=0;
		public var twelfth_percent : Number=0.00;
		public var twelfth_days : int=0;
		public var display_order : int=0;
		public function PaymentPlan(label:String="id")
		{
			super(label);
		}
	}
}