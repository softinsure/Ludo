/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: NameInput.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	
	import mx.containers.FormItem;
	import mx.controls.Text;
	
	import org.ludo.components.base.BaseInput;
	import org.ludo.components.mxml.CTextInput;
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.FormBuilder;
	
	public class NameInput extends BaseInput
	{
		public var firstName:CTextInput = new CTextInput();
		public var lastName:CTextInput = new CTextInput();
		public var middleName:CTextInput = new CTextInput();
		public var namelabel:Text = new Text();
		private var lblwidth:int=200;
		public function NameInput(pageid:String,fieldElement:XML=null,parentType:String="form",readonly:Boolean=false,dataMapArray:Array=null,xmlMapArray:Array=null)
		//public function NameInput(required:String="false",label:String=null)
		{
			super(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
			//super(fieldElement,parentType,dataMapArray,xmlMapArray);
			lblwidth=FormBuilder.getInstance().labelWidth;
			if(label!=null && label!="")
			{
				namelabel.text = label;
			}
			else
			{
				namelabel.text = "Name(First, Middle, Last)";
			}
			namelabel.width=lblwidth;
			firstName.width=120;
			middleName.width=60;
			lastName.width=120;
			//default length
			firstName.maxChars=30;
			middleName.maxChars=20;
			lastName.maxChars=30;
			var s1:FormItem = new FormItem();			
			s1.direction="horizontal";
			s1.addChild(namelabel);
			s1.addChild(firstName);
			s1.addChild(middleName);
			s1.addChild(lastName);
			//if(required!=null && required=="true")
			if(requiredFlag)
			{
				s1.required=true;
			}
			this.addElement(s1);
			//setID(String(fieldElement.@id));
			//setValidation(String(fieldElement.@id),String(fieldElement.@validation))
			setID();
			setValidation();
			setXmlMap([this.firstName,this.lastName,this.middleName],["First Name","Last Name","Middle Name"]);
			setDataMap([this.firstName,this.lastName,this.middleName],["First Name","Last Name","Middle Name"]);
			if(readfrom!="")
			{
				readFrom([this.firstName,this.lastName,this.middleName]);
			}
			setProperties([this.firstName,this.lastName,this.middleName]);
		}
	   	public function setName(fname:String,lname:String,mname:String=""):void {
	    	this.firstName.text=fname;
			this.lastName.text=lname;
			this.middleName.text=mname;
		}
	   	public function setLength(nameLength:Array):void {
			if(nameLength.length>0)
			{
				this.firstName.maxChars=nameLength[0];
			}
			if(nameLength.length>1)
			{
				this.lastName.maxChars=nameLength[1];
			}
			if(nameLength.length>2)
			{
				this.middleName.maxChars=nameLength[2];
			}
		}
	   	//private function setValidation(vArray:Array,validation:String):void {
//		private function setValidation(id:String,validation:String):void {
		private function setValidation():void {
			if(validation!="")
			{
				addValidation(this.firstName,validation,this.ID+"_firstName");
				addValidation(this.lastName,validation,this.ID+"_lastName");
				//CustomValidator.createValidators(this.firstName,vArray,validation);
				//CustomValidator.createValidators(this.lastName,vArray,validation);
			}
		}
		private function setID():void {
			if(this.ID!="")
			{
				addElmentByID(this.ID+"_firstName",this.firstName);
				addElmentByID(this.ID+"_middleName",this.middleName);
				addElmentByID(this.ID+"_lastName",this.lastName);
				addElmentByID("lbl_"+this.ID,this.namelabel);
				addElmentByID("parent_"+this.ID,this);
			}
		}
	}
}