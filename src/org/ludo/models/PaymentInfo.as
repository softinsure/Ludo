package org.ludo.models
{
	import mx.managers.CursorManager;
	import mx.utils.ObjectUtil;
	
	import org.common.utils.XDateUtil;
	import org.frest.Fr;
	import org.ludo.controllers.ErrorController;
	
	[Resource(name="list")]
  	[Resource(xmlroot="list")]
  	[Bindable]
	public class PaymentInfo extends BaseModel
	{
		public var query : String;
		[Ignored]
		private var quote:Quote;
		[Ignored]
		private var effectivedate : Date;
		[Ignored]
		private var seq :Array=['first','second','third','fourth','fifth','sixth','seventh','eighth','ninth','tenth','eleventh','twelfth'];
		[Ignored]
		public var results : XML;
		[Ignored]
		public var rows : XMLList;
		//[Ignored]
		//public var template : XML;
		[Ignored]
		public var selectone:Boolean=true;
		[Ignored]
		public var schedules:Array=[];
		[Ignored]
    	[HasOne]
    	[Ignored]
    	public var paymentplan:PaymentPlan;
		public function PaymentInfo(quoteToSchedule:Quote)
		{
			doUnmarshall=false;
			//this.template=LudoUtils.templateController.getTemplate("paymentinfo");
			this.quote=quoteToSchedule;
			//this.quote.xmlstore.payment_schedule=(this.template.children()[0] as XML).copy();
			this.effectivedate=(quote.policy_effective_date==null)?new Date():XDateUtil.getDate((quote.policy_effective_date));
			generateQuery();
			this.list();
		}
		[Ignored]
		override protected function onSuccess(event:Object):void
		{
			super.onSuccess(event);
/*			error=false;
			serverError=null;
			message="";
			var result : Object = event.result;
			if (result == "error")
			{
				error=true;
				message="There was an error. Please try again later!";
			}
			else if(result is XML)
			{
				var resultXML : XML = XML(result);
				if (resultXML.name().localName == "errors")
				{
					validationerror=true;
					serverError=resultXML;
				}
				else
				{
					this.paymentplan = new PaymentPlan("paymentschedule");
					//unmarshal quote
					Fr.serializer.unmarshall(XML(event.result..row),this.paymentplan);
					this.setSchedule();
				}
			}
*/			if(result is XML && result!=null)
			{
				this.paymentplan = new PaymentPlan("paymentschedule");
				//unmarshal quote
				if(event.result..row!=null)
				{
					Fr.serializer.unmarshall(XML(event.result..row),this.paymentplan);
				}
				this.setSchedule();
			}
		}
		[Ignored]
		private function generateQuery():void
		{
			this.query="select * from payment_plans where lob = '"+quote.lob+"' and plan_code='"+quote.payment_plan+"'";
		}
		[Ignored]
		protected override function onFailure(event:Object):void
		{
			CursorManager.removeBusyCursor();
			if(error)
			{
				ErrorController.logErrorTwo("PaymentSchedule action failure at fault: " + ObjectUtil.toString(event),"Command","CreateRecordCommand");
				//PageManager.getInstance().showPageErrorMsg(message,"fault");
			}
		}
		[Ignored]
		public function setSchedule() : void
		{
			this.quote.installment=0.00;
			this.quote.policy_fee=paymentplan.policy_fee;
			this.quote.total_charge=Number(this.quote.quoted_premium+paymentplan.policy_fee);
			schedules=[];
			var payment_xml:XML=new XML('<Schedules/>');
			var aSchedule:Schedule=new Schedule();
			aSchedule.item='Minimum Down Payment';
			aSchedule.amount=((paymentplan.down_payment*quote.quoted_premium/100)+paymentplan.policy_fee).toFixed(2);
			//set min down
			this.quote.min_down=Number(aSchedule.amount);
			//+paymentplan.policy_fee).toFixed(2);
			aSchedule.duedate=XDateUtil.formatDate(effectivedate.toString());
			schedules.push(aSchedule);
			payment_xml.appendChild(aSchedule.getXMLNode);
			for(var i:int=0;i<paymentplan.installment_number;i++)
			{
				var aSchedule1:Schedule=new Schedule();
				aSchedule1.item='Installment '+(i+1);
				aSchedule1.amount=((paymentplan[seq[i]+"_percent"]*quote.quoted_premium/100)+paymentplan.installment_fee).toFixed(2);//+paymentplan.policy_fee).toFixed(2);
				//first one is installmet fee
				if(i==0)
				{
					this.quote.installment=Number(aSchedule1.amount);
				}
				aSchedule1.duedate=XDateUtil.formatDate(XDateUtil.dateAdd(effectivedate.toString(),paymentplan[seq[i]+"_days"]).toString());
				schedules.push(aSchedule1);
				payment_xml.appendChild(aSchedule1.getXMLNode);		
				
			}
			this.quote.xmlstore.payment_schedule=payment_xml;
			this.quote.changed;
			this.quote.changed;
			this.quote.xmlstore.changed;
		}
	}
}
class Schedule extends Object
{
	public var item:String="";
	public var amount:String="";
	public var duedate:String="";

	public function Schedule()
	{
		super();
	}
	public function get getXMLNode():XML
	{
		return <Schedule><Item>{item==null?"":item}</Item><Amount>{amount==null?"":amount}</Amount><DueDate>{duedate==null?"":duedate}</DueDate></Schedule>;
		//return new XML(("<schedule><item>"+item==null?"":item+"</item><amount>"+amount==null?"":amount+"</amount><duedate>"+duedate==null?"":duedate+"</duedate></schedule>"));
	}
}
