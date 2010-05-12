package org.ludo.models
{
	import org.frest.collections.FrModelCollection;

	[Resource(name="policy_headers")]
	[Bindable]
	public class PolicyHeader extends BaseModel
	{
		public var policy_prefix:String;
		public var policy_suffix:String;
		public var policy_number:String;
		public var prior_policy_number:String;
		[DateTime]
		public var org_effective_date:String;
		[DateTime]
		public var last_endorsement_text:String;
		public var last_endorsed_dt:String;
		public var current_status:String;
		public var current_activity:String;
		public var num_endorsed:int;
		public var num_renewed:int;
		public var num_reinstated:int;
		public var policy_id:int;
		[HasMany]
		public var policy:FrModelCollection;//=new FrModelCollection();
		
		public function PolicyHeader(label:String="id")
		{
			super(label);
		}
		[Ignored]
		public static function newPolicyHeader(policyToAdd:Policy):PolicyHeader
		{
			var aHeader:PolicyHeader=new PolicyHeader("newPolicyHeader");
			if(aHeader.policy == null)
			{
				aHeader.policy=new FrModelCollection();
			}
			aHeader.policy.addModel(policyToAdd);
			aHeader.policy_prefix=policyToAdd.quote.lob;
			aHeader.org_effective_date=policyToAdd.quote.policy_effective_date;
			aHeader.current_status="NB";
			aHeader.current_activity="ENTERED";
			aHeader.num_endorsed=0;
			aHeader.num_reinstated=0;
			aHeader.num_renewed=0;
			aHeader.changed=true;
			aHeader.policy_id=policyToAdd.id;
			policyToAdd.policyHeader=aHeader;
			return aHeader;
		}
		[Ignored]
		public function makeCurrentPolicy(policy:Policy):void
		{
			this.policy_id=policy.id;
		}
		[Ignored]
		public function endorseHeader(currentPolicy:Policy):void
		{
			this.policy_id=currentPolicy.id;
			if(this.policy == null)
			{
				this.policy=new FrModelCollection();
			}
			this.policy.addModel(currentPolicy);
			this.current_status="A";
			this.current_activity="Endorsed";
			currentPolicy.transaction_reason=this.last_endorsement_text;
			this.num_endorsed=this.num_endorsed+1;
			this.changed=true;
		}
	}
}