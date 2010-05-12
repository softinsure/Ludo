/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: BaseInput.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.base
{
	import flash.display.DisplayObject;
	
	import org.ludo.utils.FormBuilder;
	import org.ludo.utils.LudoUtils;
	
	import spark.components.VGroup;
	/**
	 * this class is and extension of VGroup and base of all custom inputs  
	 * @author Goutam
	 * 
	 */	
	public class BaseInput extends VGroup
	{
		//protected var required:String="false";
		protected var requiredFlag:Boolean=false;
		protected var validation:String="";
		protected var label:String="";
		protected var dataMapArray:Array;
		protected var xmlMapArray:Array;
		protected var fieldElement:XML;
		protected var parentType:String;
		protected var pageid:String="";
		protected var small:Boolean=false;
		protected var readfrom:String="";
		protected var properties:String="";
		protected var ID:String="";
		/**
		 * 
		 * @param pageid
		 * @param fieldElement
		 * @param parentType
		 * @param readonly
		 * @param dataMapArray
		 * @param xmlMapArray
		 * 
		 */
		public function BaseInput(pageid:String,fieldElement:XML=null,parentType:String="form",readonly:Boolean=false,dataMapArray:Array=null,xmlMapArray:Array=null)
		{
			super();
			if(fieldElement!=null)
			{
				ID=String(fieldElement.@id);
				requiredFlag=LudoUtils.pageController.requiredField(pageid,fieldElement);
				if(requiredFlag)
				{
					//add validation
					if(String(fieldElement.@type).toLowerCase()=="contractterminput")
					{
						validation=(validation!=""?validation+";":"date|")+"required=true";
					}
					else
					{
						validation=(validation!=""?validation+";":"default|")+"required=true";
					}
				}
				this.fieldElement=fieldElement;
				//required=String(this.fieldElement.@requiredflag);
				label=String(this.fieldElement.@label);
				if(String(fieldElement.@small)=='true')
				{
					small=true;
				}
				this.readfrom=String(fieldElement.@readfrom)
			}
			properties=String(fieldElement.@properties);
			if(readonly || LudoUtils.pageController.ifReadOnly(pageid))
			{
				if(properties=="")
				{
					properties="enabled=false";
				}
				else if(properties.indexOf('enabled=false',0)==-1)
				{
					properties=properties+";enabled=false";
				}
			}
			this.dataMapArray=dataMapArray;
			this.xmlMapArray=xmlMapArray;
			this.parentType=parentType;
			this.pageid=pageid;
		}
		protected function setProperties(controlstoMap:Array):void 
		{
			if(properties.length>0)
			{
				for each (var control:DisplayObject in controlstoMap)
				{
					LudoUtils.setFieldProperties(control,properties);
				}
			}
		}
		protected function readFrom(controlstoMap:Array):void 
		{
			if(this.readfrom!="")
			{
				var childmap:Array=String(fieldElement.@readfromchild).split(",");
				if(childmap.length>0)
				{
					var builder:FormBuilder = FormBuilder.getInstance();
					for(var i:int=0;i<childmap.length;i++)
					{
						if(childmap[i].toString()!="" && controlstoMap.length>i)
						{
							//first time read
							if(LudoUtils.getFieldValue(controlstoMap[i])=="")
							{
								LudoUtils.setFieldValue(controlstoMap[i],LudoUtils.getValueFromReadFrom(readfrom+"."+childmap[i].toString()));
							}
						}
					}
				}
			}
		}
		protected function setDataMap(controlstoMap:Array,controlsDesc:Array):void 
		{
			if(fieldElement.hasOwnProperty("@datamap") && dataMapArray!=null)
			{
				var childmap:Array=String(fieldElement.@datamap).split(",");
				var fieldAction:String=String(fieldElement.@datamapaction).toLowerCase();
				if(childmap.length>0)
				{
					var builder:FormBuilder = FormBuilder.getInstance();
					for(var i:int=0;i<childmap.length;i++)
					{
						if(childmap[i].toString()!="" && controlstoMap.length>i)
						{
							var desc:String="undefined";
							if(controlsDesc.length>i)
							{
								desc=controlsDesc[i];
							}
							if(label!="")
							{
								desc=label+" "+desc;
							}
							if(parentType=="unit")
							{
								dataMapArray.push(LudoUtils.getNewDataMapping(desc,controlstoMap[i],childmap[i].toString(),fieldAction));
							}
							else
							{
								dataMapArray.push(LudoUtils.getNewDataMapping(desc,controlstoMap[i],childmap[i].toString(),fieldAction));
							}
							if(fieldAction!='save')
							{
								LudoUtils.setBindProperty(controlstoMap[i],LudoUtils.modelController.collections,childmap[i].toString());
							}
						}
					}
				}
			}
		}
		protected function addElmentByID(id:String,obj:*):void
		{
			if(id.length>0)
			{
				obj["id"]=id;
				LudoUtils.pageController.addElmentByID(pageid,id,obj);
			}
		}
		protected function addValidation(fieldtovalidate:*,validationString:String,id:String=""):void
		{
			LudoUtils.pageController.addValidationToPage(pageid,fieldtovalidate,validationString,id);
		}
		protected function setXmlMap(controlstoMap:Array,controlsDesc:Array):void 
		{
			var fieldAction:String=String(fieldElement.@xmlmapaction).toLowerCase();
			//check if xmlmap
			if(fieldElement.hasOwnProperty("@xmlmap"))
			{
				
				var xmlMap:String=String(fieldElement.@xmlmap);
				var childmap:Array=String(fieldElement.@childmap).split(",");
				var findByChildTag:String=String(fieldElement.@filterbychildtag);
				if(xmlMap=="/")
				{
					xmlMap="";
				}
				if(childmap.length>0)
				{
					var builder:FormBuilder = FormBuilder.getInstance();
					for(var i:int=0;i<childmap.length;i++)
					{
						if(childmap[i].toString()!="" && controlstoMap.length>i)
						{
							var desc:String="undefined";
							if(controlsDesc.length>i)
							{
								desc=controlsDesc[i];
							}
							if(parentType=="unit")
							{
								xmlMapArray.push(LudoUtils.getNewXmlMapping(desc,controlstoMap[i],xmlMap+childmap[i].toString(),null,fieldAction,findByChildTag));
								//xmlMapArray.push([controlstoMap[i],xmlMap+childmap[i].toString(),fieldAction,findByChildTag])
							}
							else
							{
								var xmlnode:XML=builder.getXMLNodeByXpath(xmlMap+childmap[i].toString(),findByChildTag,childmap[i]);
								if(xmlnode!=null)
								{
									if(fieldAction!='save')
									{
										LudoUtils.setNodeValueToField(controlstoMap[i],xmlnode);
									}
								}
								xmlMapArray.push(LudoUtils.getNewXmlMapping(desc,controlstoMap[i],xmlMap+childmap[i].toString(),xmlnode,fieldAction,(findByChildTag!="")?findByChildTag+"^"+childmap[i].toString():""));
								//xmlMapArray.push([controlstoMap[i],xmlMap+childmap[i].toString(),xmlnode,fieldAction,(findByChildTag!="")?findByChildTag+"^"+childmap[i].toString():""])
							}
						}
					}
				}
			}
		}
	}
}