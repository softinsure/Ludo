/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: PhoneInput.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.containers.FormItem;
	import mx.controls.Text;
	
	import org.ludo.components.base.BaseInput;
	import org.ludo.components.mxml.CDropDownList;
	import org.ludo.components.mxml.CTextInput;
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.FormBuilder;
	import org.ludo.utils.LudoUtils;
	
	public class PhoneInput extends BaseInput
	{
		public var phone:CTextInput = new CTextInput();
		public var phoneType:CDropDownList = new CDropDownList();
		public var phonelabel:Text = new Text();
		//private var requiredFlag:String="false";
		private var lblwidth:int=200;
		//public function PhoneInput(phonetype:String="true",required:String="false",label:String=null)
		public function PhoneInput(pageid:String,fieldElement:XML=null,parentType:String="form",readonly:Boolean=false,dataMapArray:Array=null,xmlMapArray:Array=null)
		{
			super(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
			//super(fieldElement,parentType,dataMapArray,xmlMapArray);
			lblwidth=FormBuilder.getInstance().labelWidth;
			phonelabel.text="Home Phone";
			if(label!=null && label!="")
			{
				phonelabel.text = label;
			}

			phonelabel.width=lblwidth;
			var s1:FormItem = new FormItem();
			//var ph:FormItem = new FormItem();
			s1.direction="horizontal";
			s1.addChild(phonelabel);
			if(String(fieldElement.@phonetype)!="false")
			{
				s1.addChild(phoneType);
				phonelabel.text = phonelabel.text + "(Type, Number)";
				if(String(fieldElement.@defaulttype)!="")
				{
					phoneType.selectedItem=String(fieldElement.@defaulttype);
				}
			}
			s1.addChild(phone);
			phone.maxChars=12;
			phone.restrict="0-9";
			phone.addEventListener(Event.CHANGE,formatPhone);
			setPhoneTypeList(FormBuilder.getInstance().optionArrayFormSource("xml::basecombolist::phonetype"));

			//if(required!=null && required=="true")
			if(requiredFlag)
			{
				s1.required=true;
//				requiredFlag="true";
			}
			this.addElement(s1);
			setID();
			setValidation()
			setXmlMap([this.phoneType,this.phone],["Type","Phone"]);
			setDataMap([this.phoneType,this.phone],["Type","Phone"]);
			if(readfrom!="")
			{
				readFrom([this.phoneType,this.phone]);
			}
			setProperties([this.phoneType,this.phone]);
		}
		public function setDefaultPhoneType(type:String):void
		{
			phoneType.selectedItem=type;
		}
        public function formatPhone(event:Event):void
        {
        	switch(phone.text.length)
			{
				case 3:
				case 7:
					phone.text=phone.text+'-';
					LudoUtils.setCursorPositionInTextInput(phone,phone.text.length);
				break;
				default:
					break;
			}
		}
		private function setPhoneTypeList(list:ArrayCollection):void {
			this.phoneType.dataProvider=list;
			//this.phoneType.labelField="@label";
			this.phoneType.selectedValue="Home";
		}	
	   	//private function setValidation(vArray:Array,validation:String):void {
		private function setValidation():void {
			//var id:String=String(fieldElement.@id);
			//var validation:String=String(fieldElement.@validation);
			if(validation!="")
			{
				addValidation(this.phone,validation,this.ID+"_phone");
				//CustomValidator.createValidators(this.phone,vArray,validation);
			}
			addValidation(this.phone,"phone|property=text",this.ID+"_type");
			//CustomValidator.createValidators(this.phone,vArray,"phone|property=text");
		}
		private function setID():void {
			//var id:String=String(fieldElement.@id);
			if(this.ID!="")
			{
				addElmentByID(this.ID+"_phone",this.phone);
				addElmentByID(this.ID+"_type",this.phoneType);
				addElmentByID("lbl_"+this.ID,this.phonelabel);
				addElmentByID("parent_"+this.ID,this);
			}
		}
	}
}