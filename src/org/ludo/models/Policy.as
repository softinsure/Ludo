package org.ludo.models
{
	import org.frest.Fr;
	

	[Resource(name="policies")]
	[Bindable]
	public class Policy extends BaseModel
	{
		/*
		public var policy_prefix:String;
		public var policy_suffix:String;
		public var policy_number:String;
		public var prior_policy_number:String;
		[DateTime]
		public var org_effective_date:String;
		public var current_status:String;
		public var num_endorsed:int;
		public var num_renewed:int;
		public var num_reinstated:int;
		*/
		public var quote_id:int;
		public var policy_header_id:int;
		public var transaction_code:String;
		public var transaction_reason:String;
		[DateTime]
		public var term_effective_date:String;
		[DateTime]
		public var term_expiration_date:String;
		[HasOne]
		public var quote:Quote;
		[Ignored]
		[BelongsTo]
		public var policyHeader:PolicyHeader;
		
		public function Policy(label:String="id")
		{
			super(label);
		}
		[Ignored]
		public static function newPolicy(quoteToAdd:Quote,makeCurrent:Boolean=false,transCode:String="NB",transReason:String="New Business"):Policy
		{
			var aPolicy:Policy=new Policy("newPolicy");
			aPolicy.quote=quoteToAdd;
			aPolicy.transaction_code=transCode;
			aPolicy.transaction_reason=transReason;
			aPolicy.changed=true;
			aPolicy.term_effective_date=aPolicy.quote.policy_effective_date;
			aPolicy.term_expiration_date=aPolicy.quote.policy_expiration_date;
			aPolicy.quote_id=quoteToAdd.id;
			quoteToAdd.policy=aPolicy;
			if(makeCurrent)
			{
				aPolicy.beforeNextTransaction=aPolicy.afterCreatePolicy;
			}
			return aPolicy;
		}
		[Ignored]
		public function endorsePolicy(currentQuote:Quote):void
		{
			this.term_effective_date=currentQuote.policy_effective_date;
			this.term_expiration_date=currentQuote.policy_expiration_date;
			this.quote=currentQuote;
			this.changed=true;
			this.policyHeader.endorseHeader(this);
		}
		[Ignored]
		public function afterCreatePolicy(event:Object):void
		{
			if(policyHeader!= null)
			{
				policyHeader.makeCurrentPolicy(this);
				policyHeader.addFieldsForDirectUpdate(["policy_id"])
				Fr.crudTransactionQueue.addModelAsFirstElementOfQueue(policyHeader,"directupdate");
			}
		}
		/*
		public function createNewPolicy():void
		{
			quote=LudoUtils.modelController.quote;
			quote.policy_id=this.id;
			this.policy_prefix=quote.lob;
			this.org_effective_date=quote.policy_effective_date;
			this.current_status="NB";
			this.num_endorsed=0;
			this.num_reinstated=0;
			this.num_renewed=0;
			//this.quote_id=quoteToAttach.id;
			this.changed=true;
			//this.belongsTo=quoteToAttach;
			//quoteToAttach.policy=this;
		}
		*/
	}
}