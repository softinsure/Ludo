/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: AddesssInput.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import flash.events.Event;
	
	import mx.containers.FormItem;
	import mx.controls.Text;
	
	import org.ludo.components.base.BaseInput;
	//import org.ludo.components.mxml.CComboBox;
	import org.ludo.components.mxml.CDropDownList;
	import org.ludo.components.mxml.CTextInput;
	import org.ludo.utils.FormBuilder;
	import org.ludo.utils.LudoUtils;
	
	public class AddesssInput extends BaseInput
	{
		public var street:CTextInput = new CTextInput();
		public var street2:CTextInput = new CTextInput();
		public var city:CTextInput = new CTextInput();
		public var zip:CTextInput = new CTextInput();
		public var state:CDropDownList = new CDropDownList();
		//public var state:CComboBox = new CComboBox();
		public var addlabel:Text = new Text();
		public var streetlabel:Text = new Text();
		public var street2label:Text = new Text();
		public var citylabel:Text = new Text();
		public var statelabel:Text = new Text();
		private var zipvalidator:String="zipcode|property=text";
		private var lblwidth:int=200;
		public function AddesssInput(pageid:String,fieldElement:XML=null,parentType:String="form",readonly:Boolean=false,dataMapArray:Array=null,xmlMapArray:Array=null)
		{
			super(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
			lblwidth=FormBuilder.getInstance().labelWidth;
			if(label!=null && label!="")
			{
				addlabel.text = label;
				addlabel.width=lblwidth;
				var al:FormItem = new FormItem();
				al.addChild(addlabel);
				this.addElement(al);
			}
			/*
			else
			{
				addlabel.text = "Insured Address";
			}
			*/
			streetlabel.width=lblwidth;
			street2label.width=lblwidth;
			citylabel.width=lblwidth;
			statelabel.width=lblwidth;
			streetlabel.text="Street";
			street2label.text="2nd Street";
			if(small)
			{
				citylabel.text="City";
				statelabel.text="State, Zip";
				state.width=130;
			}
			else
			{
				citylabel.text="City, State, Zip";
			}			
			city.width=100;
			zip.width=80;
			//state.width=100;

			var s1:FormItem = new FormItem();
			s1.direction="horizontal";
			s1.addChild(streetlabel);
			s1.addChild(street);
			addElmentByID("parent_"+id+"_street",s1);

			var s2:FormItem = new FormItem();
			s2.direction="horizontal";
			s2.addChild(street2label);
			s2.addChild(street2);
			addElmentByID("parent_"+id+"_street2",s2);

			var s3:FormItem = new FormItem();
			s3.direction="horizontal";
			s3.addChild(citylabel);
			s3.addChild(city);
			if(small)
			{
				var s4:FormItem = new FormItem();
				s4.direction="horizontal";
				s4.addChild(statelabel);
				s4.addChild(state);
				s4.addChild(zip);
			}
			else
			{
				s3.addChild(state);
				s3.addChild(zip);
			}
			addElmentByID("parent_"+id+"_city",s3);
			
			//if(required!=null && required=="true")
			if(requiredFlag)
			{
				s1.required=true;
				//s2.required=true;
				s3.required=true;
				if(small)
				{
					s4.required=true;
				}
				zipvalidator=zipvalidator+";required=true";
			}			
			this.addElement(s1);
			this.addElement(s2);
			this.addElement(s3);
			if(small)
			{
				this.addElement(s4);
				addElmentByID("parent_"+id+"_state",s4);
			}
			setStateList(FormBuilder.getInstance().optionArrayFormSource("xml::basecombolist::state"));
			this.zip.restrict="[0-9]";
			this.zip.maxChars=10;
			this.zip.addEventListener(Event.CHANGE,formatZip);
			//setID(String(fieldElement.@id));
			//setValidation(String(fieldElement.@id),String(fieldElement.@validation))
			setID();
			setValidation();
			setXmlMap([this.street,this.street2,this.city,this.state,this.zip],["Street","2nd Street","City","State","Zip"]);
			setDataMap([this.street,this.street2,this.city,this.state,this.zip],["Street","2nd Street","City","State","Zip"]);
			if(readfrom!="")
			{
				readFrom([this.street,this.street2,this.city,this.state,this.zip]);
			}
			setProperties([this.street,this.street2,this.city,this.state,this.zip]);
			//setMapToArray();
		}
		/*
		private function init():void
		{
			setStateList(FormBuilder.getInstance().optionArrayFormSource("xml::basecombolist::state"));
		}
		*/
		public function setAddress(street:String,city:String,state:String,zip:String):void {
	    	this.street.text=street;
			this.city.text=city;
			this.state.selectedValue=state;
			//this.state.text=state;
			this.zip.text=zip;
		}
	  	private function setStateList(list:*):void {
			this.state.dataProvider=list;
			this.state.selectedItem="";
		}	
        private function formatZip(event:Event):void
        {
        	switch(this.zip.text.length)
			{
				case 6:
					var zipcode:String=zip.text;
					zip.text=zipcode.substr(0,5)+'-'+zipcode.substr(5,1);
					LudoUtils.setCursorPositionInTextInput(zip,zip.text.length);
				break;
				default:
					break;
			}
		}
		//private function setValidation(id:String,validation:String):void {
		private function setValidation():void {
	   		if(validation!="")
			{
				addValidation(this.street,validation,this.ID+"_street");
				addValidation(this.city,validation,this.ID+"_city");
				addValidation(this.state,validation,this.ID+"_state");
				addValidation(this.zip,validation,this.ID+"_zip");
			}
			addValidation(this.zip,zipvalidator,this.ID+"_zip");
		}
 		//private function setID(id:String):void
		private function setID():void
		{
			if(this.ID!="")
			{
				addElmentByID(this.ID+"_street",this.street);
				addElmentByID(this.ID+"_stree2",this.street2);
				addElmentByID(this.ID+"_city",this.city);
				addElmentByID(this.ID+"_state",this.state);
				addElmentByID(this.ID+"_zip",this.zip);
				addElmentByID("lbl_"+this.ID,this.addlabel);
				addElmentByID("parent_"+this.ID,this);
			}
		}
	}
}