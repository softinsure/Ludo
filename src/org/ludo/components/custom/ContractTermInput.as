/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: ContractTermInput.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import flash.events.Event;
	
	import mx.containers.FormItem;
	import mx.controls.DateField;
	import mx.controls.Text;
	import mx.formatters.DateFormatter;
	
	import org.common.utils.XDateUtil;
	import org.ludo.components.base.BaseInput;
	import org.ludo.components.mxml.CDateField;
	import org.ludo.components.mxml.CTextInput;
	import org.ludo.utils.FormBuilder;
	import org.ludo.utils.LudoUtils;
	
	public class ContractTermInput extends BaseInput
	{
		public var effDate:CDateField = new CDateField();
		public var expDate:CTextInput = new CTextInput();
		public var polTerm:CTextInput = new CTextInput();
		public var efflbl:Text = new Text();
		public var explbl:Text = new Text();
		public var termlbl:Text = new Text();
		public var duration:int=6;//default
		public var defaultEffDate:Date=new Date();//default
		private var dateFormatter:DateFormatter = new DateFormatter();
		private var lblwidth:int=200;
		//public function ContractTermInput(required:String="false",label:String=null)
		public function ContractTermInput(pageid:String,fieldElement:XML=null,parentType:String="form",readonly:Boolean=false,dataMapArray:Array=null,xmlMapArray:Array=null)
		{
			super(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
			//super(fieldElement,parentType,dataMapArray,xmlMapArray);
			lblwidth=FormBuilder.getInstance().labelWidth;
			dateFormatter.formatString=effDate.formatString;
			efflbl.text="Effective Date";
			explbl.text="Expiration Date";
			termlbl.text="Term in Months";
			if(label!=null && label!="")
			{
				efflbl.text=label+" "+efflbl.text;
				explbl.text=label+" "+explbl.text;			
				termlbl.text=label+" "+termlbl.text;			
			}
			efflbl.width=lblwidth;
			explbl.width=lblwidth;
			termlbl.width=lblwidth;
			expDate.editable=false;
			expDate.width=effDate.width;
			polTerm.editable=false;
			polTerm.width=effDate.width;

			var eff:FormItem = new FormItem();
			eff.direction="horizontal";
			eff.addChild(efflbl);
			eff.addChild(effDate);
			addElmentByID("parent_"+id+"_effDate",eff);

			var exp:FormItem = new FormItem();
			exp.direction="horizontal";
			exp.addChild(explbl);
			exp.addChild(expDate);
			addElmentByID("parent_"+id+"_expDate",exp);

			var term:FormItem = new FormItem();
			term.direction="horizontal";
			term.addChild(termlbl);
			term.addChild(polTerm);
			addElmentByID("parent_"+id+"_polTerm",term);
			//if(required!=null && required=="true")
			if(requiredFlag)
			{
				eff.required=true;
				//s2.required=true;
				exp.required=true;
			}			
			this.addElement(eff);
			this.addElement(exp);
			this.addElement(term);
			effDate.addEventListener(Event.CHANGE,onChangeEffDate);
			init();
			setID();
			setValidation()
			setDataMap([this.effDate,this.expDate,this.polTerm],["Effective Date","Expiration Date","Policy Term"]);
			setXmlMap([this.effDate,this.expDate,this.polTerm],["Effective Date","Expiration Date","Policy Term"]);
			if(readfrom!="")
			{
				readFrom([this.effDate,this.expDate,this.polTerm]);
			}
			if(polTerm.text=='')
			{
				polTerm.text=String(duration);
			}
			if(this.effDate.text=="")//no date
			{
				this.effDate.text=XDateUtil.getCurrentDate();
			}
			setProperties([this.effDate,this.expDate,this.polTerm]);
			setExpDate();
		}
		private function init():void
		{
			if(LudoUtils.modelController.quote!=null)
			{
				this.duration=LudoUtils.modelController.quote.policy_term;
			}
			effDate.text=dateFormatter.format(defaultEffDate.toDateString());
			//expDate.text=dateFormatter.format(DateUtils.dateAdd("m",duration,defaultEffDate).toLocaleDateString());
			//polTerm.text=duration.toString();
		}
		public function onChangeEffDate(event:Event):void {
	    	setExpDate();
		}
		public function setExpDate():void {
	    	expDate.text=dateFormatter.format(XDateUtil.dateAdd("m",duration,DateField.stringToDate(effDate.text,effDate.formatString)));
		}
		//private function setValidation(vArray:Array,validation:String):void {
		private function setValidation():void {
			//var id:String=String(fieldElement.@id);
			//var validation:String=String(fieldElement.@validation);
			if(validation=="")
			{
				validation="date|";
			}
			else if(validation.indexOf('date|',0)==-1)
			{
				throw new Error("Invalid date validation string! Use 'date|'");
			}
			if(validation!="")
			{
				addValidation(this.effDate,validation,this.ID+"_effDate");
				addValidation(this.expDate,validation,this.ID+"_expDate");
			}
		}
 		private function setID():void {
			//var id:String=String(fieldElement.@id);
			if(this.ID!="")
			{
				addElmentByID(this.ID+"_effDate",this.effDate);
				addElmentByID(this.ID+"_expDate",this.expDate);
				addElmentByID(this.ID+"_polTerm",this.polTerm);
				addElmentByID("lbl_"+this.ID+"_effDate",this.efflbl);
				addElmentByID("lbl_"+this.ID+"_expDate",this.explbl);
				addElmentByID("lbl_"+this.ID+"_polTerm",this.termlbl);
				addElmentByID("parent_"+this.ID,this);
			}
		}
	}
}