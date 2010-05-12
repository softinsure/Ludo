package org.ludo.utils
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.*;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.utils.StringUtil;
	
	import org.common.utils.XStringUtil;
	import org.ludo.collections.DataStore;
	import org.ludo.collections.ReferencedMethods;
	import org.ludo.components.mxml.*;
	import org.ludo.connectors.ImageConnector;
	import org.ludo.controllers.ChangeDetailController;
	import org.ludo.controllers.ConfigurationController;
	import org.ludo.controllers.ContainerController;
	import org.ludo.controllers.ErrorController;
	import org.ludo.controllers.LoginController;
	import org.ludo.controllers.ModelController;
	import org.ludo.controllers.NavController;
	import org.ludo.controllers.PageController;
	import org.ludo.controllers.PagesAndPropertiesController;
	import org.ludo.controllers.TransController;
	import org.ludo.models.BaseModel;
	import org.ludo.objects.DataMap;
	import org.ludo.objects.XmlMap;
	
	import spark.components.Application;
	import spark.components.ComboBox;
	import spark.components.DropDownList;
	//import spark.components.TextInput;
	

	public class LudoUtils
	{
		/*
		public function Common()
		{
		}
		*/
		private static var configController:ConfigurationController=ConfigurationController.getInstance();
		[Bindable] public static var modelController:ModelController=ModelController.getInstance();
		public static var transController:TransController=TransController.getInstance();
		public static var navController:NavController=NavController.getInstance();
		public static var loginController:LoginController=LoginController.getInstance();
		public static var dataStore:DataStore=DataStore.getInstance();
		[Bindable] public static var pageController:PageController=PageController.getInstance();
		public static var containerController:ContainerController=ContainerController.getInstance();
		public static var formBuilder:FormBuilder=FormBuilder.getInstance();
		[Bindable] public static var lookupSource:LookupSource=LookupSource.getInstance();
		public static var firstTimeDefault:FirstTimeDefault=FirstTimeDefault.getInstance();
		public static var pagesAndPropsController:PagesAndPropertiesController=PagesAndPropertiesController.getInstance();
		public static var changeDetailController:ChangeDetailController=ChangeDetailController.getInstance();
		public static var referencedMethods:ReferencedMethods=ReferencedMethods.getInstance();

		public static function cleanObjects():void
		{
/*			dataStore=null;
			modelController=null;
			transController=null
			pageController=null;
			containerController=null;
			formBuilder=null;
			pagesAndPropsController=null;
			changeDetailController=null;
			referencedMethods=null;
*/		}

		public static function get xmlMapper():XMLMapper
		{
			return modelController.xmlMapper;
		}
		public static function getClassReferenceByName(className:String):Class
		{
			return ClassReference.getClassReferenceByName(className);
		}
		public static function getFunctionReferenceByName(className:String,funcName:String):Function
		{
			return ClassReference.getFunctionReferenceByName(className,funcName);
		}
		public static function getFunctionReferenceByFullPath(funcName:String):Function
		{
			return ClassReference.getFunctionReferenceByFullPath(funcName);
		}
		private static function labelPlacement(iconPos:String):String
		{
			switch(iconPos.toLowerCase())
			{
				case 'left':
					return ButtonLabelPlacement.RIGHT;
					break;
				case 'right':
					return ButtonLabelPlacement.LEFT;
				case 'top':
					return ButtonLabelPlacement.BOTTOM;
				case 'bottom':
					return ButtonLabelPlacement.TOP;
				default:
					return ButtonLabelPlacement.RIGHT;
			}
		}
		public static function setIconToButton(target:Button,iconPath:String):void
		{
			var iArray:Array=iconPath.split("::");
			target.labelPlacement=labelPlacement(iArray.length>1?iArray[1]:"left");
			target.setStyle("icon",ImageConnector.getImageByName(iArray[0]));
		}
		public static function getNewDataMapping(description:String,displplayObject:DisplayObject,fieldMap:String,fieldAction:String="",fieldType:String="",defaultValue:String=""):DataMap
		{
			var newDataMap:DataMap=new DataMap();
			newDataMap.description=description;
			newDataMap.displayObject=displplayObject;
			newDataMap.fieldaction=fieldAction;
			newDataMap.fieldmap=fieldMap;
			newDataMap.fieldtype=fieldType;
			newDataMap.defaultvalue=defaultValue;
			return newDataMap;
		}
		public static function getNewXmlMapping(description:String,displplayObject:DisplayObject,fieldMap:String,node:XML,fieldAction:String="",findByChildTag:String="",fieldType:String="",defaultValue:String=""):XmlMap
		{
			var newDataMap:XmlMap=new XmlMap();
			newDataMap.description=description;
			newDataMap.displayObject=displplayObject;
			newDataMap.fieldaction=fieldAction;
			newDataMap.fieldmap=fieldMap;
			newDataMap.node=node;
			newDataMap.findByChildTag=findByChildTag;
			newDataMap.fieldtype=fieldType;
			newDataMap.defaultvalue=defaultValue;
			return newDataMap;
		}
		public static function isEmpty(str:String):Boolean
		{
			return XStringUtil.isEmpty(str);
		}
		public static function booleanValue(str:String="false"):Boolean
		{
			return str=="true"?true:false;
		}
		public static function get applicationUsed():Application
		{
			return FlexGlobals.topLevelApplication as Application;
		}
		public static function set enableApplication(value:Boolean):void
		{
			applicationUsed.enabled=value;
		}
		public static function isANumber(str:String):Boolean { return !isNaN(Number(str));}

		//end state related
		public static function getIntiatedObject(className:String):*
		{
			var clazz:Class=null;
			try
			{
				clazz = getDefinitionByName(className) as Class;
				if(clazz!=null)
				{
					return new clazz() as Object;
				}
				else
				{
					throw new Error("Invalid clas name "+className+"!");
				}
	        	}
        	catch (e:Error)
        	{
        		ErrorController.logError(e,"Invalid Class Path","getIntiatedObject");
        	}
        }
        public static function getConfigValue(key:String):String
        {
        	return configController.configvalue(key);
        }
		public static function getFullName(fname:String,lname:String,mname:String=""):String
		{
			mname=StringUtil.trim(mname);
			return fname+" "+((mname=="null" || mname=="")?"":mname+" ")+lname;
		}
        public static function displayDateFormat():String
        {
        	var format:String=getConfigValue("displaydateformat");
        	return format==""?"MM/DD/YYYY":format;
        }
        public static function dbDateFormat():String
        {
        	var format:String=getConfigValue("dbdateformat");
        	return format==""?"YYYY-MM-DD":format;
        }
		public static function keepFirstNodeInXmlList(nodeList:XMLList):void
		{
			if(nodeList.length()>1)
			{
				for( var i:int=nodeList.length()-1; i>=1;i--) 
				{
					delete nodeList[i];
				}
			}
		}
		public static function getIndexOfComboBoxByVal(cbox:ComboBox, data:String ):int
		{
			for( var i:int = 0; i < cbox.dataProvider.length; ++i ) 
			{
				if( cbox.dataProvider.getItemAt(i).data == data )
				return i;
			}
			return -1;
		}
		public static function getValueOfComboBox(cbox:ComboBox):*
		{
         	if(cbox.selectedIndex>=0)
         	{
            	return cbox.dataProvider[cbox.selectedIndex].data;
          	}
          	return "";
		}
		public static function getIndexOfDropDownListByVal(list:DropDownList, data:String ):int
		{
			for( var i:int = 0; i < list.dataProvider.length; ++i ) 
			{
				if( list.dataProvider.getItemAt(i).data == data )
					return i;
			}
			return -1;
		}
		public static function getValueOfDropDownList(list:DropDownList):*
		{
			if(list.selectedIndex>=0)
			{
				return list.dataProvider[list.selectedIndex].data;
			}
			return "";
		}
		public static function setCursorPositionInTextInput(field:TextInput,pos:int):void
		{
			//field.selectRange(pos,pos);
			field.selectionBeginIndex=pos;
			field.selectionEndIndex=pos;
		}
 		public static function setCursorPositionInTextArea(field:TextArea,pos:int):void
		{
			field.selectionBeginIndex=pos;
			field.selectionEndIndex=pos;
		}
		public static function setObjectProperties(obj:Object,properties:String):void
		{
			if(obj!=null && properties.length>0)
			{
				for each(var prop:String in properties.split(";"))
				{
					var vProp:Array=prop.split("=");
					if(vProp.length==2)
					{
						switch(vProp[0].toString())
						{
							//exceptions in case
							//this will grow in course of time
							case 'exception':
								//write exception logic here
							break;
							case 'property':
								//write exception logic here
							break;
							default:
								obj[vProp[0]]=vProp[1];
							break;
						}
					}
				}
			}
		}
		public static function setDataProvider(formitem:IVisualElement,list:ArrayCollection):void
		{
			if(formitem!=null)
			{
				switch(formitem['className'].toString())
				{
					case 'CComboBox':
						(formitem as CComboBox).dataProvider=list;
						break;
					case 'CDropDownList':
						(formitem as CDropDownList).dataProvider=list;
						break;
					case 'CRadioList':
						(formitem as CRadioList).dataProvider=list;
						break;
					case 'DropDownList':
						(formitem as DropDownList).dataProvider=list;
					case 'ComboBox':
						(formitem as ComboBox).dataProvider=list;
						//getValueOfComboBox(formitem as ComboBox).dataProvider=list;
						break;
					default:
						break
				}
			}
		}
		public static function getFieldValue(formitem:DisplayObject):String
		{
			var _retval:String="";
			if(formitem!=null)
			{
				switch(formitem['className'].toString())
				{
					case 'CComboBox':
						_retval=(formitem as CComboBox).selectedValue.toString();
						break;
					case 'CDropDownList':
						_retval=(formitem as CDropDownList).selectedValue.toString();
						break;
					case 'CRadioList':
						_retval=(formitem as CRadioList).selectedValue.toString();
						break;
					case 'ComboBox':
						_retval=getValueOfComboBox(formitem as ComboBox).toString();
					case 'DropDownList':
						_retval=getValueOfDropDownList(formitem as DropDownList).toString();
						break;
					//case 'CDateField':
					//case 'DateField':
						//_retval=Formatter.formatDateString(formitem['text'],"YYYY-MM-DD");
						//break;
					default:
						_retval=formitem['text'];
						break
				}
			}
			return _retval;			
		}
		public static function enabled(formitem:DisplayObject):Boolean
		{
			var _retval:Boolean=false;
			if(formitem!=null)
			{
				switch(formitem['className'].toString())
				{
					case 'CComboBox':
						_retval=(formitem as CComboBox).enabled;
						break;
					case 'CDropDownList':
						_retval=(formitem as CDropDownList).enabled;
						break;
					case 'CRadioList':
						_retval=(formitem as CRadioList).enabled;
						break;
					case 'ComboBox':
						_retval=(formitem as ComboBox).enabled;
						break;
					case 'DropDownList':
						_retval=(formitem as DropDownList).enabled;
						break;
					default:
						_retval=formitem['editable'];
						if(_retval)
						{
							_retval=formitem['enabled'];
						}
						break
				}
			}
			return _retval;			
		}
		public static function getFieldType(formitem:DisplayObject):String
		{
			if(formitem!=null)
			{
				return formitem['className'].toString();
			}
			return "";			
		}
		public static function getFieldValueBeforeSave(formitem:DisplayObject):String
		{
			var _retval:String="";
			if(formitem!=null)
			{
				if(formitem.hasOwnProperty('valuebeforesave'))
				{
					//set to old prop
					_retval=formitem['valuebeforesave'];
				}
			}
			return _retval;			
		}
		public static function getValueFromReadFrom(readFrom:String):String
		{
			var fromArray:Array=readFrom.split("::");
			if(fromArray.length>1)
			{
				switch(fromArray[0].toString().toLowerCase())
				{
					case 'model':
						/*
						//get from model controller
						var fields:Array = fromArray[1].toString().split(".");
						var currentData:Object=modelController;
						for each(var f : String in fields)
						{
							if(currentData.hasOwnProperty(f))
							{
								currentData = currentData[f];
							}
							else
							{
								throw new Error("Invalid model path "+fromArray[1].toString()+"!");
							}
						}
						*/
						return getValueFromChain(modelController,fromArray[1]);
					break
					case 'default'://get default
					case 'defaultvalue'://get default
							return fromArray[1].toString();
					case 'xml'://get from xml
						return "";
					break
				}
				return "";
			}
			else
			{
				throw new Error("Invalid readFrom "+readFrom+"!");
			}
		}
		public static function setFieldValueBeforeSave(formitem:DisplayObject,value:String):void
		{
			if(formitem!=null)
			{
				if(formitem.hasOwnProperty('valuebeforesave'))
				{
					//set to old prop
					formitem['valuebeforesave']=value;
				}
			}
		}
		public static function setNodeValueToFieldToSave(formitem:DisplayObject, node:XML):void
		{
			if(formitem!=null)
			{
				setFieldValueToSave(formitem,getNodeValue(node));
			}
		}
		public static function setNodeValueToField(formitem:DisplayObject, node:XML):void
		{
			if(formitem!=null)
			{
				setFieldValue(formitem,getNodeValue(node));
			}
		}
		/*
		public static function setNodeValueToField(formitem:DisplayObject, node:XML):void
		{
			if(formitem!=null)
			{

				var value:String="";
				if(node!=null)
				{
					switch(node.nodeKind())
					{
						case 'element':
						case 'text':
							value=node.toString();
							break;
						default:
							value=node.toString();
							break
					}
				}
				setFieldValue(formitem,value);
			}
		}
		*/
		public static function setFieldSetValueToField(formitem:DisplayObject, fieldset:String):void
		{

			var source:Array = fieldset.split("::");
			var labelFields:XMLList;
			var rootpath:String="";//this path indicates to get value using this xpath from workitem(acord), default to acord
			if(source.length>=1)
			{
				//get the labelFields
				//first element is the fieldset id
				//collect from lookup source
				labelFields=LudoUtils.lookupSource.getFieldSets(source[0]).children();
				if(source.length>=2)//you have root path
				{
					rootpath=source[1];//root path
				}
			}
			var label:String="";
			var sourceXml:XML=LudoUtils.modelController.xmlMapper.getNodeByXpath(rootpath)[0];
			for each (var field:XML in labelFields)
			{
				switch(String(field.@type).toLowerCase())
				{
					case 'string':
						label=label+field.toString();
						break;
					case 'space':
						label=label+" ";
						break;
					case 'field':
						if(sourceXml==null) break;
						var fieldval:String=XMLMapper.getNodeByXpathAndRootNode(sourceXml,field.toString()).toString();
						if(String(field.@lookupsource)!="")
						{
							fieldval=LudoUtils.lookupSource.getValueFromLookupSource(String(field.@lookupsource),fieldval);
						}
						//label=label+XMLMapper.getNodeByXpathAndRootNode(XMLList(data)[0],field.toString()).toString();
						label=label+fieldval;
						break;
					default:
						label=label+field.toString();
						break
				}				
			}
			setFieldValue(formitem,label);
		}
		public static function setFieldValueToNode(node:XML,stringToUpdate:String):void
		{
			if(node!=null)
			{
				switch(node.nodeKind())
				{
					case 'attribute':
						node.parent()[node.name()]=stringToUpdate;
						break;
					default:
						node.parent().children()[node.childIndex()]=stringToUpdate;
						break
				}
			}		
		}
		public static function getRESTUrl(objectID:String,action:String):String
		{
			return LudoUtils.dataStore.getFromXmlContainer("resturl").url.(@id == objectID)[action];
		}
		public static function getNodeValue(node:XML):String
		{
			/*
			var value:String="";
			if(node!=null)
			{
				switch(node.nodeKind())
				{
					case 'element':
					case 'text':
						value=node.toString();
						break;
					default:
						value=node.toString();
						break
				}
			}
			return value;
			*/
			return XMLMapper.getNodeValue(node);
		}
		public static function setFieldValue(formitem:DisplayObject, value:String):void
		{
			if(formitem!=null)
			{
				/*
				switch(formitem['className'].toString())
				{
					case 'CComboBox':
						(formitem as CComboBox).selectedValue=value;
						//(formitem as ComboBox).labelField="@label";
						if((formitem as CComboBox).selectedItem==null)
						{
							(formitem as CComboBox).selectedIndex=0;
						}
						break;
					case 'CRadioList':
						(formitem as CRadioList).selectedValue=value;
						//(formitem as ComboBox).labelField="@label";
						break;
					case 'ComboBox':
						var cBox:CComboBox=formitem as CComboBox;
						cBox.selectedIndex=getIndexOfComboBoxByVal(cBox,value);
						break;
					default:
						formitem['text']=value;
						break
				}
				*/
				setFieldValueToSave(formitem,value);
				setFieldValueBeforeSave(formitem,value);
			}
		}
		public static function setFieldValueToSave(formitem:DisplayObject, value:String):void
		{
			if(formitem!=null)
			{
				switch(formitem['className'].toString())
				{
					case 'CComboBox':
						(formitem as CComboBox).selectedValue=value;
						//(formitem as ComboBox).labelField="@label";
						if((formitem as CComboBox).selectedItem==null)
						{
							(formitem as CComboBox).selectedIndex=0;
						}
						break;
					case 'CDropDownList':
						(formitem as CDropDownList).selectedValue=value;
						break;
					case 'CRadioList':
						(formitem as CRadioList).selectedValue=value;
						//(formitem as ComboBox).labelField="@label";
						break;
					case 'ComboBox':
						var cBox:CComboBox=formitem as CComboBox;
						cBox.selectedIndex=getIndexOfComboBoxByVal(cBox,value);
						break;
					case 'DropDownList':
						var list:DropDownList=formitem as DropDownList;
						list.selectedIndex=getIndexOfDropDownListByVal(list,value);
						break;
					default:
						formitem['text']=value;
						break
				}
			}
		}
		public static function getObjectFromChain(host:Object,chain:String):*
		{
			var splitChain:Array=chain.split('.');
			var obj:Object=host;
			for each(var f : String in splitChain)
			{
				if(obj[f]==null)
				{
					//try lower case
					obj = obj[f.toLowerCase()];
					//f=f.toLowerCase();
				}
				else
				{
					obj = obj[f];
				}
			}
			return obj;		
		}
		/*
		public static function setValueToModel(host:Object,chain:String,value:String):void
		{
			var splitChain:Array=chain.split('.');
			var obj:Object=host;
			for each(var f : String in splitChain)
			{
				if(obj[f] is String)
				{
					obj[f]=value;
					break;
				}
				obj = obj[f];
			}
		}
		*/
		public static function setValueToModel(host:Object,chain:String,value:String,modelChanged:Boolean=false):void
		{
			var splitChain:Array=chain.split('.');
			var obj:Object=host;
			var parent:Object=host;
			var attribute:String="";
			for each(var f : String in splitChain)
			{
				if(obj.hasOwnProperty(f))
				{
					parent=obj;
					attribute=f;
					obj = obj[f];
				}
				else
				{
					throw new Error("Invalid model path "+chain+"!");
				}
			}
			if(parent is BaseModel)
			{
				if(parent[attribute] == null ||String(parent[attribute])!=value)
				{
					parent[attribute]=value;
					(parent as BaseModel).changed=modelChanged;
				}
			}
		}
		public static function getValueFromChain(host:Object,chain:String):String
		{
			return String(getObjectFromChain(host,chain));
			//return obj is String?String(obj):"";
		}
		public static function setBindProperty(formitem:Object,host:Object,datamap:String):void
		{
			if(formitem!=null)
			{
				var dataarray:Array=datamap.split(".");
				var prop:String="text";
				if(dataarray.length>1)
				{
					switch(formitem['className'].toString())
					{
						case 'CDropDownList':
						case 'DropDownList':
						case 'CComboBox':
						case 'ComboBox':
							prop="selectedValue";
							break;
						default:
							prop="text";
							break
					}
					BindingUtils.bindProperty(formitem,prop,host,dataarray);
					if(formitem.hasOwnProperty('valuebeforesave'))
					{
						//set to old prop
						//BindingUtils.bindProperty(formitem,"valuebeforesave",host,dataarray);
						setFieldValueBeforeSave(formitem as DisplayObject,getValueFromChain(host,datamap));
					}
				}
			}
		}
		public static function filterByViewMode(objectsorginal:XMLList,pageid:String=""):XMLList
		{
			//get a clone so that original list dont get changed
			var objects:XMLList=objectsorginal.copy();
			if(pageid=="")
			{
				pageid=pageController.currentPageID;
			}
			//if(objects.hasOwnProperty('@viewmode'))
			//{
				//delete objects.(attribute("viewmode")!="" && attribute("viewmode")!=pageController.viewMode);
				for(var i:int=objects.length()-1;i>=0;i--)
				{
					/*
					var vMode:String=String(objects[i].@viewmode);
					if(vMode!="" && vMode!=pageController.viewMode)
					{
					delete objects[i];
					}
					*/
					if(!pageController.viewPageControl(pageid,objects[i]))
					{
						delete objects[i];
					}
				}
			//}
			return objects;
		}
        public static function getActionBar(data:XML,pageid:String=""):ActionButtonBar
        {
			var ctlBar:ActionButtonBar=new ActionButtonBar();
			ctlBar.setBar(data,pageid);
            return ctlBar
        }
        public static function getControlButtonBar(_gridColumn:XML,pageid:String=""):ControlButtonBar
        {
 			var funcParam:String=String(_gridColumn.@methodparam);
 			var parentFunc:String=String(_gridColumn.@method);
 			var paramArray:Array;
			if(funcParam!="")
			{
				paramArray=funcParam.split(",");
			}
			else
			{
				paramArray=[];
			}
			var ctlBar:ControlButtonBar=new ControlButtonBar();
			ctlBar.setBtnArray=filterByViewMode(_gridColumn.object,pageid);
			ctlBar.setParentFunctionByName=parentFunc;
			ctlBar.setFunctionParamn=paramArray;
			ctlBar.setButtonStyle=String(_gridColumn.@buttonbarstyle)
            return ctlBar
        }
        public static function getSearchHeaderButtonBar(_gridColumn:XML,pageid:String=""):ControlButtonBar
        {
 			var funcParam:String=String(_gridColumn.@methodparam);
 			var parentFunc:String=String(_gridColumn.@method);
 			var paramArray:Array;
			if(funcParam!="")
			{
				paramArray=funcParam.split(",");
			}
			else
			{
				paramArray=[];
			}
			if(isEmpty(parentFunc))
			{
				parentFunc="org.ludo.controllers.ActionController.modelSearchHeaderButtonBarClicked";
			}
			var ctlBar:ControlButtonBar=new ControlButtonBar();
			ctlBar.setBtnArray=filterByViewMode(_gridColumn.object,pageid);
			ctlBar.setParentFunctionByName=parentFunc;
			ctlBar.setFunctionParamn=paramArray;
			ctlBar.setButtonStyle=String(_gridColumn.@buttonbarstyle)
            return ctlBar
        }
		public static function setViewStackSelectedIndex(viewstack:ViewStack,index:int):void
		{
			if(viewstack!=null)
			{
				viewstack.selectedIndex=index;
			}
		}
		public static function setObjectID(object:Object,id:String):void
		{
			if(id.length>0)
			{
				object["id"]=id;
				object["name"]=id;
			}
		}
		public static function setFieldProperties(formitem:DisplayObject,properties:String):void
		{
			if(formitem!=null && properties.length>0)
			{
				for each(var prop:String in properties.split(";"))
				{
					var vProp:Array=prop.split("=");
					if(vProp.length==2)
					{
						if(formitem.hasOwnProperty(vProp[0]))
						{
							formitem[vProp[0]]=vProp[1];
							if(vProp[1]=="true")
							{
								formitem[vProp[0]]=true;
							}
							else if(vProp[1]=="false")
							{
								formitem[vProp[0]]=false;
							}
							else
							{
								formitem[vProp[0]]=vProp[1];
							}
						}
						else
						{
							throw new Error("Invalid property "+vProp[0]+"!");
						}
					}
				}
			}
		}

///////////////////////////////////////
	}
}