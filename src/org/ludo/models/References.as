package org.ludo.models
{
	import org.frest.models.FrReferences;

	public class References extends FrReferences
	{
		//define class references here
		private var paymentplan:PaymentPlan;
		private var pageUpdatedInfo:PageUpdatedInfo;
		private var policy:Policy;
		private var xmlstore:Xmlstore;
		private var policyHeader:PolicyHeader;
		private var groupactivity:GroupActivity;
		private var group:Group;
		private var lob:LineOfBusiness;
		private var configxml:ConfigXml;
		public static function initiateReferences():void
		{
			addClassPath("org.ludo.models");
		}
	}
}