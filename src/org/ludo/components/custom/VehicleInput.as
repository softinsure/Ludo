/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: VehicleInput.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.containers.FormItem;
	import mx.controls.Text;
	
	import org.common.utils.XDateUtil;
	import org.ludo.components.base.BaseInput;
	import org.ludo.components.mxml.CDropDownList;
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.FormBuilder;
	import org.ludo.utils.LudoUtils;
	
	public class VehicleInput extends BaseInput
	{
/*		public var vehicleyear:CComboBox = new CComboBox();
		public var vehiclemake:CComboBox = new CComboBox();
		public var vehiclemodel:CComboBox = new CComboBox();
*/	
		public var vehicleyear:CDropDownList = new CDropDownList();
		public var vehiclemake:CDropDownList = new CDropDownList();
		public var vehiclemodel:CDropDownList = new CDropDownList();
		public var vehiclelabel:Text = new Text();
		private var makelookupsource:String="xml::pa_combolist::vehiclemake";//default
		private var startyear:int=1990;//default
		private var lblwidth:int=200;
		//public function VehicleInput(required:String="false",label:String=null)
		public function VehicleInput(pageid:String,fieldElement:XML=null,parentType:String="form",readonly:Boolean=false,dataMapArray:Array=null,xmlMapArray:Array=null)
		{
			super(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
			lblwidth=FormBuilder.getInstance().labelWidth;
			if(label!=null && label!="")
			{
				vehiclelabel.text = label;
			}
			else
			{
				vehiclelabel.text = "Year, Make, Model";
			}
			vehiclelabel.width=lblwidth;
			var s1:FormItem = new FormItem();			
			s1.direction="horizontal";
			s1.addChild(vehiclelabel);
			s1.addChild(vehicleyear);
			s1.addChild(vehiclemake);
			s1.addChild(vehiclemodel);
//			if(required!=null && required=="true")
			if(requiredFlag)
			{
				s1.required=true;
			}
			this.addElement(s1);
			if(String(fieldElement.@startyear)!="")
			{
				this.startYear=fieldElement.@startyear;
			}
			if(String(fieldElement.@makelookupsource)!="")
			{
				this.makeLookupSource=String(fieldElement.@makelookupsource);
			}
			init();
			//setID(String(fieldElement.@id));
			setID();
			//setValidation(String(fieldElement.@id),String(fieldElement.@validation))
			setValidation()
			setXmlMap([this.vehicleyear,this.vehiclemake,this.vehiclemodel],["Year","Make","Model"]);
			setDataMap([this.vehicleyear,this.vehiclemake,this.vehiclemodel],["Year","Make","Model"]);
			if(readfrom!="")
			{
				readFrom([this.vehicleyear,this.vehiclemake,this.vehiclemodel]);
			}
			setProperties([this.vehicleyear,this.vehiclemake,this.vehiclemodel]);
		}
		private function resetList(event:Event):void
		{
			this.vehiclemake..selectedIndex=0;
			setModelList();
		}
		private function populateModel(event:Event):void
		{
		}
		private function setYearList():void
		{
			var curyear:int = XDateUtil.currentYear()+1;
			var optCol:ArrayCollection=new ArrayCollection();
			var obj:Object=new Object();
			obj.label='Select One';
			obj.data='';
			optCol.addItem(obj);
			for(var i:int=startyear;i<=curyear;i++)
			{
				var obj2:Object=new Object();
				obj2.label=i.toString();
				obj2.data=i.toString();
				optCol.addItem(obj2);				
			}
			vehicleyear.dataProvider=optCol;
			vehicleyear.selectedIndex=0;
		}
		private function setMakeList():void
		{
			this.vehiclemake.dataProvider=LudoUtils.lookupSource.optionArray(makelookupsource);
			this.vehiclemake..selectedIndex=0;
		}
		private function setModelList():void
		{
			this.vehiclemodel.dataProvider=LudoUtils.lookupSource.optionArray("xml::pa_combolist::blankmodel");
			this.vehiclemodel..selectedIndex=0;
		}
		private function init():void
		{
			setYearList();
			setMakeList();
			setModelList();
			vehicleyear.addEventListener(Event.CHANGE,resetList);
			vehiclemake.addEventListener(Event.CHANGE,populateModel);
		}
	   	public function set startYear(year:int):void {
			this.startyear=year;
		}
		public function set makeLookupSource(lookupsource:String):void {
			if(lookupsource!="")//need to sent lookup source make
			{
				this.makelookupsource=lookupsource;
			}
			else
			{
				throw new Error("Lookup source make not available.");
			}
		}
		//private function setValidation(vArray:Array,validation:String):void {
		//private function setValidation(id:String,validation:String):void {
		private function setValidation():void {
			if(validation!="")
			{
				addValidation(this.vehicleyear,validation,this.ID+"_vehicleyear");
				addValidation(this.vehiclemake,validation,this.ID+"_vehiclemake");
				addValidation(this.vehiclemodel,validation,this.ID+"_vehiclemodel");
				//CustomValidator.createValidators(this.vehicleyear,vArray,validation);
				//CustomValidator.createValidators(this.vehiclemake,vArray,validation);
				//CustomValidator.createValidators(this.vehiclemodel,vArray,validation);
			}
		}
		//private function setID(id:String):void {
		private function setID():void {
			if(this.ID!="")
			{
				addElmentByID(this.ID+"_vehicleyear",this.vehicleyear);
				addElmentByID(this.ID+"_vehiclemake",this.vehiclemake);
				addElmentByID(this.ID+"_vehiclemodel",this.vehiclemodel);
				addElmentByID("lbl_"+this.ID,this.vehiclelabel);
				addElmentByID("parent_"+this.ID,this);
			}
		}
	}
}