package org.ludo.utils
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.FormHeading;
	import mx.containers.FormItem;
	import mx.containers.Panel;
	import mx.controls.Spacer;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.*;
	import mx.core.IVisualElement;
	import mx.events.ListEvent;
	
	import org.ludo.components.custom.AddesssInput;
	import org.ludo.components.custom.ContractTermInput;
	import org.ludo.components.custom.CoverageInput;
	import org.ludo.components.custom.ImageAsButton;
	import org.ludo.components.custom.NameInput;
	import org.ludo.components.custom.PhoneInput;
	import org.ludo.components.custom.VehicleInput;
	import org.ludo.components.mxml.*;
	import org.ludo.controllers.ActionController;
	import org.ludo.controllers.MessageController;
	import org.ludo.layouts.ActionBar;
	import org.ludo.layouts.DataEntryVBox;
	import org.ludo.layouts.PageHeaders;
	import org.ludo.layouts.PageMsgBox;
	import org.ludo.layouts.PanelBox;
	//import org.ludo.layouts.PanelTipBox;
	import org.ludo.layouts.SectionHeaders;
	import org.ludo.layouts.TipBox;
	import org.ludo.models.*;
	import org.ludo.views.UnitEditGrid;
	
	import r1.deval.D;
		
	[Bindable]
	public class FormBuilder
	{
		//private var lookupSource:LookupSource=LookupSource.getInstance();
		private var screenxml:XML;// = LudoUtils.dataStore.getFromXmlContainer("screen");
		private var rightscreenxml:XML;// = LudoUtils.dataStore.getFromXmlContainer("screen");
		private var PageID:String = "default";
		private var xmlMapper:XMLMapper;
		
		private var defaultLabelWidth:int=200;
		private var currentLabelWidth:int=200;
		private var ifProcessingPageReadOnly:Boolean=true;

		private var defaultRightLabelWidth:int=100;
		private var currentRightLabelWidth:int=100;
		
		private static var formbuilder:FormBuilder;

        public static function getInstance():FormBuilder{
            if (formbuilder == null) {
                formbuilder = new FormBuilder();

            }
            return formbuilder;
        }
        public function get labelWidth():int
        {
        	return currentLabelWidth;
        }
        public function get rightLabelWidth():int
        {
        	return currentRightLabelWidth;
        }
        public function initialize():void
        {
        	//reset screen xml for new transaction
        	screenxml=LudoUtils.dataStore.getFromXmlContainer(LudoUtils.transController.screenid);
        	rightscreenxml=LudoUtils.dataStore.getFromXmlContainer(LudoUtils.transController.rightScreenid);
        	//xmlMapper
        	xmlMapper = LudoUtils.modelController.xmlMapper;
        	//default label width
        	if(String(LudoUtils.transController.getProperty("defaultlabelwidth"))!="")
        	{
        		defaultLabelWidth=int(LudoUtils.transController.getProperty("defaultlabelwidth"));
        		currentLabelWidth=defaultLabelWidth;
        	}
        	if(String(LudoUtils.transController.getProperty("defaultrightlabelwidth"))!="")
        	{
        		
        		defaultRightLabelWidth=int(LudoUtils.transController.getProperty("defaultrightlabelwidth"));
        		currentRightLabelWidth=defaultRightLabelWidth;
        	}
        }
        //The constructor should be private, but this is not
        //possible in ActionScript 3.0. So, throwing an Error if
        //a second AppLudoUtils.dataStore is created is the best we
        //can do to implement the Singleton pattern.
        public function FormBuilder() {
            if (formbuilder != null) {
                throw new Error("Only one FormBuilder instance may be instantiated.");
            }
        }
        /*
		public function optionList(optionid:String):XMLList
		{
			return combolistxml.options.(@id == optionid);
		}
		*/
		public function optionArrayFormSource(lookupsource:String):ArrayCollection
		{
			return LudoUtils.lookupSource.optionArray(lookupsource);
		}
		public function setArrayFormSource(lookupsource:String,displayObject:IVisualElement):void
		{
			LudoUtils.lookupSource.setOptionArray(lookupsource,displayObject);
		}
		/*
		public function labelFields(id:String):XMLList
		{
			return labelviews.fieldSet.(@id == id);
		}
		*/
		private function AddLabel(pageid:String,fieldid:String,displaybject:FormItem,pLabel:String,style:String=""):void
		{
			/*
			if(pLabel.length>0)
			{
				var aLabel:Label=new Label();
				aLabel.text = pLabel;
				aLabel.width=currentLabelWidth;
				displaybject.addChild(aLabel);
			}
			*/
			if(pLabel.length>0)
			{
				var aLabel:Text=new Text();
				aLabel.text = pLabel;
				aLabel.width=currentLabelWidth;
				displaybject.addChild(aLabel);
				if(style!="")
				{
					aLabel.styleName=style;
				}
				else
				{
					aLabel.styleName="label";
				}
				if(fieldid.length>0)
				{
					LudoUtils.pageController.addElmentByID(pageid,"lbl_"+fieldid,aLabel);
					//CurrentPage.addElmentByID("lbl_"+fieldid,aLabel);
				}
			}
		}
		private function AddFormHeader(displaybject:Panel,headertext:String,width:int=300):void
		{
			var aFormHeading:FormHeading=new FormHeading();
			aFormHeading.label = headertext;
			aFormHeading.width=width;
			displaybject.addChild(aFormHeading);		
		}
		public function getXMLNodeByXpath(xpath:String,filtertag:String="",childnodetoreturn:String=""):XML
		{
			if(filtertag!="")
			{
				var xml:XML=(xmlMapper.getNodeByXpath(filtertag)[0] as XML);
				if(xml!=null)
				{
					if(childnodetoreturn!="")
					{
						return XMLMapper.getNodeByXpathAndRootNode(xml.parent(),childnodetoreturn)[0];
					}
					else
					{
						return xml.parent();
					}
				}
				else
				{
					return null;
				}
			}
			else
			{
				return xmlMapper.getNodeByXpath(xpath)[0];
			}

		}
		private function onSelect(displayObject:IVisualElement,functionpath:String):void
		{
			if (functionpath != "")
			{
				var parentFunction:Function=LudoUtils.getFunctionReferenceByFullPath(functionpath);
				if(parentFunction!=null)
				{
					displayObject.addEventListener(ListEvent.CHANGE,parentFunction);
				}
			}
		}
		private function onChange(displayObject:IVisualElement,functionpath:String):void
		{
			if (functionpath != "")
			{
				var parentFunction:Function=LudoUtils.getFunctionReferenceByFullPath(functionpath);
				if(parentFunction!=null)
				{
					displayObject.addEventListener(Event.CHANGE,parentFunction);
				}
			}
		}
		private function setFinder(fString:String):ImageAsButton
		{
			var fArray:Array=fString.split("::");
			if(fArray.length>=4)//it has correct number of params
			{
				var btn:ImageAsButton= new ImageAsButton("finder");
				var retFunc:String=fArray.length==5?fArray[4]:"";
				btn.setParentFunction=ActionController.popUpFinder;
				btn.setFunctionParamn=[fArray[0],fArray[1],fArray[2],fArray[3],fArray.length==5?fArray[4]:""];
				return btn;
			}
			return null;
		}
		private function getValidatorType(fieldType:String):String
		{
			switch(fieldType)
			{
				case 'contractterminput':
				case 'datefield':
					return "date";
					break;
				default:
					return "default";
					break;
			}				
			
		}
		private function AddFormItem
		(
			pageid:String,
			fieldElement:XML,
			parentType:String="form",
			readonly:Boolean=false,
			dataMapArray:Array=null,
			xmlMapArray:Array=null,
			coverageArray:Array=null,
			ctlToRefresh:Array=null
		):IVisualElement
		{
			var fieldID:String = String(fieldElement.@id);
			var fieldType:String=String(fieldElement.@type).toLowerCase();
			var frmItem:FormItem = new FormItem();			
			frmItem.direction = "horizontal";
			//first return
			switch(fieldType.toLowerCase())
			{
				case 'spacer':
					var spacer:Spacer = new Spacer()
					if(String(fieldElement.@height)!="")
					{
						spacer.width=fieldElement.@height;
					}
					LudoUtils.pageController.addElmentByID(pageid,fieldID,spacer);
					//CurrentPage.addElmentByID(fieldID,spacer);
					return spacer;
					break;
				case 'secheader':
					var secheader:SectionHeaders = new SectionHeaders();
					secheader.label=fieldElement.@title;
					if(String(fieldElement.@properties)!="")
					{
						LudoUtils.setFieldProperties(secheader,fieldElement.@properties);
					}
					LudoUtils.pageController.addElmentByID(pageid,fieldID,secheader);
					//CurrentPage.addElmentByID(fieldID,secheader);
					return secheader;
					break;
				case 'message':
					var message:PageMsgBox = new PageMsgBox();
					var msgtype:String=String(fieldElement.@messagetype);
					if(msgtype=="")
					{
						msgtype="information";
					}
					message.setMessage(String(fieldElement.@label),msgtype);
					LudoUtils.pageController.addElmentByID(pageid,fieldID,message);
					//CurrentPage.addElmentByID(fieldID,secheader);
					return message;
					break;
				case 'buttonbar':
					//filter object
					return LudoUtils.getControlButtonBar(fieldElement,pageid);
					break;
				case 'actionbuttonbar':
					return LudoUtils.getActionBar(fieldElement,pageid);
					break;
				case 'password':
				case 'textinput':
				case 'datefield':
				case 'textarea':
				case 'combobox':
				case 'dropdownlist':
				case 'radiolist':
				case 'xmltree':
					AddLabel(pageid,fieldID,frmItem,fieldElement.@label,fieldElement.@labelstyle);
					break;
				case 'display':
					if(String(fieldElement.@labelstyle)!="")
					{
						AddLabel(pageid,fieldID,frmItem,fieldElement.@label,fieldElement.@labelstyle);
					}
					else
					{
						AddLabel(pageid,fieldID,frmItem,fieldElement.@label,"displayLabel");
					}
					break;
				default:
					break;
			}
			var fieldMap:String=String(fieldElement.@datamap);
			var xmlMap:String=String(fieldElement.@xmlmap);
			var findByChildTag:String=String(fieldElement.@filterbychildtag);
			var dataMapAction:String=String(fieldElement.@datamapaction).toLowerCase();
			var xmlMapAction:String=String(fieldElement.@xmlmapaction).toLowerCase();
			var validation:String=String(fieldElement.@validation);
			var xmlnode:XML;
			var displayobject:DisplayObject;
			var defaultval:String="";
			var requiredFlag:Boolean=LudoUtils.pageController.requiredField(pageid,fieldElement);

			if(String(fieldElement.@readfrom)!="" && String(fieldElement.@readfromchild)=="")
			{
				defaultval=LudoUtils.getValueFromReadFrom(String(fieldElement.@readfrom));
			}
			if(requiredFlag)
			{
				//add validation
				validation=(validation!=""?validation+";":getValidatorType(fieldType)+"|")+"required=true";
			}
			if(ifProcessingPageReadOnly)
			{
				readonly=true;
			}
			switch(fieldType)
			{
				//case 'button':
					//return frmItem.addChild(Common.CreateDataGridColumnButton(fieldElement));
					//break;
				case 'datefield':
					var dateField:CDateField = new CDateField();
					dateField.text = defaultval;
					displayobject=dateField;
					frmItem.addChild(dateField);
					//add format validation
					if(validation=="")
					{
						validation="date|";
					}
					else if(validation.indexOf('date|',0)==-1)
					{
						throw new Error("Invalid date validation string! Use 'date|'");
					}
					break;
				case 'display':
					var aText:Text = new Text();
					aText.text = defaultval;
					frmItem.addChild(aText);
					if(String(fieldElement.@textstyle)!="")
					{
						aText.styleName=fieldElement.@textstyle;
					}
					else
					{
						aText.styleName="displayText";
					}
					if(fieldMap!="")
					{
						LudoUtils.setBindProperty(aText,LudoUtils.modelController.collections,fieldMap);
					}
					else if(xmlMap!="")
					{
						if(xmlMap=="/" || xmlMap==".")
						{
							xmlMap=="";
						}
						LudoUtils.setNodeValueToField(aText,getXMLNodeByXpath(xmlMap));
					}
					else if(String(fieldElement.@fieldset)!="")
					{
						LudoUtils.setFieldSetValueToField(aText,fieldElement.@fieldset);
					}
					LudoUtils.pageController.addElmentByID(pageid,fieldID,aText);
					//CurrentPage.addElmentByID(fieldID,aText);
					return frmItem;
					break;
				case 'hidden':
				case 'password':
				case 'textinput':
					var aTextInput:CTextInput = new CTextInput();
					aTextInput.text = defaultval;
					displayobject=aTextInput;
					if(fieldType.toLowerCase()=='textinput' || fieldType.toLowerCase()=='password')
					{
						frmItem.addChild(aTextInput);
					}
					if(fieldType.toLowerCase()=='password')
					{
						aTextInput.displayAsPassword=true;
					}
					onChange(aTextInput,String(fieldElement.@onchange));
					break;
				case 'textarea':
					var aTextArea:CTextArea = new CTextArea();
					aTextArea.text = defaultval;
					displayobject=aTextArea;
					frmItem.addChild(aTextArea);
					onChange(aTextInput,String(fieldElement.@onchange));
					break;
				case 'contractterminput':
					return new ContractTermInput(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
					break;
				case 'addressinput':
					return new AddesssInput(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
					break;
				case 'nameinput':
					return new NameInput(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
					break;
				case 'vehicleinput':
					return new VehicleInput(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
					break;
				case 'phoneinput':
					return new PhoneInput(pageid,fieldElement,parentType,readonly,dataMapArray,xmlMapArray);
					break;
				case 'coverageinput':
					var coverageinput:CoverageInput = new CoverageInput(pageid,fieldElement,parentType,readonly);
					coverageArray.push(coverageinput);
					return coverageinput;				
					break;
				case 'combobox':
					var aComboBox:CComboBox = new CComboBox();
					setArrayFormSource(fieldElement.@lookupsource,aComboBox);
					//aComboBox.dataProvider =optionArrayFormSource(fieldElement.@lookupsource);
					aComboBox.selectedItem=defaultval;
					onSelect(aComboBox,String(fieldElement.@onselect));
					displayobject=aComboBox;
					frmItem.addChild(aComboBox);
					break;
				case 'dropdownlist':
					var aDropDown:CDropDownList = new CDropDownList();
					setArrayFormSource(fieldElement.@lookupsource,aDropDown);
					//aComboBox.dataProvider =optionArrayFormSource(fieldElement.@lookupsource);
					aDropDown.selectedValue=defaultval;
					onSelect(aDropDown,String(fieldElement.@onselect));
					displayobject=aDropDown;
					frmItem.addChild(aDropDown);
					break;
				case 'radiolist':
					var aRadioList:CRadioList = new CRadioList();
					setArrayFormSource(fieldElement.@lookupsource,aRadioList);
					//aRadioList.dataProvider=optionArrayFormSource(fieldElement.@lookupsource);
					aRadioList.setValidation=validation;
					validation="";
					aRadioList.selectedValue=defaultval;
					displayobject=aRadioList;
					frmItem.addChild(aRadioList);
					break;
				case 'xmleditor':
					var aXmlEditor:CXmlEditor = new CXmlEditor();
					displayobject=aXmlEditor;
					frmItem.addChild(aXmlEditor);
					break;
				case 'xmltree':
					var aXmlTree:CXmlTree = new CXmlTree();
					displayobject=aXmlTree;
					frmItem.addChild(aXmlTree);
					break;
				default:
					break;
			}
			if(displayobject!=null)
			{
				if(String(fieldElement.@searchfunc)!="")
				{
					//add search button
					var btn:ImageAsButton= new ImageAsButton("finder");
					frmItem.addChild(btn);
					btn.setParentFunction=LudoUtils.getFunctionReferenceByFullPath(String(fieldElement.@searchfunc));
				}
				if(String(fieldElement.@finder)!="")
				{
					//add search button
					var btn2:ImageAsButton= setFinder(String(fieldElement.@finder));
					if(btn2==null)
					{
						throw new Error("not a valid finder source!");
					}
					frmItem.addChild(btn2);
				//	btn.setParentFunction=LudoUtils.getFunctionReferenceByFullPath(String(fieldElement.@searchfunc));
				}
				if(fieldID.length>0)
				{
					LudoUtils.pageController.addElmentByID(pageid,fieldID,displayobject);
					LudoUtils.pageController.addElmentByID(pageid,"parent_"+fieldID,frmItem);
					displayobject["id"]=fieldID;
					//CurrentPage.addElmentByID(fieldID,displayobject);
					//CurrentPage.addElmentByID("parent_"+fieldID,frmItem);
				}
				if(fieldMap!="")
				{
					//if(fieldType.toLowerCase()=='hidden' && dataMapAction!='read')
					//{
						//LudoUtils.setFieldValue(displayobject,defaultval);
					//}
					if(dataMapAction!="save")
					{
						LudoUtils.setBindProperty(displayobject,LudoUtils.modelController.collections,fieldMap);
					}
					if(dataMapArray!=null)
					{
						//dataMapArray.push([displayobject,fieldMap,xmlMapAction]);
						dataMapArray.push(LudoUtils.getNewDataMapping(fieldElement.@label,displayobject,fieldMap,dataMapAction));
					}
				}
				if(xmlMap!="")
				{
					if(xmlMap=="/" || xmlMap==".")
					{
						xmlMap=="";
					}
					switch(parentType)
					{
						case 'unit':
							xmlMapArray.push(LudoUtils.getNewXmlMapping(fieldElement.@label,displayobject,xmlMap,null,xmlMapAction,findByChildTag,fieldType,defaultval));
							//xmlMapArray.push([displayobject,xmlMap,xmlMapAction,findByChildTag,fieldType,defaultval])
						break;
						default:
							xmlnode=getXMLNodeByXpath(xmlMap);
							
							/*
							if(fieldType=='hidden' && xmlMapAction!='read')
							{
								LudoUtils.setFieldValue(displayobject,defaultval);
								LudoUtils.setFieldValueToNode(xmlnode,defaultval);
							}
							*/
							if(xmlMapAction!='save')
							{
								LudoUtils.setNodeValueToField(displayobject,xmlnode);
								//LudoUtils.setFieldValueBeforeSave(displayobject,xmlnode);
							}
							//else
							//{
								//LudoUtils.setNodeValueToField(displayobject,xmlnode);
							//}
							xmlMapArray.push(LudoUtils.getNewXmlMapping(fieldElement.@label,displayobject,xmlMap,xmlnode,xmlMapAction,findByChildTag,fieldType,defaultval));
							//xmlMapArray.push([displayobject,xmlMap,xmlnode,xmlMapAction,findByChildTag,fieldType,defaultval])
						break;
					}
				}
				if(validation!="")
				{
					LudoUtils.pageController.addValidationToPage(pageid,displayobject,validation,fieldID);
					//CurrentPage.setValidation(displayobject,validation,fieldID);
					//CustomValidator.createValidators(displayobject,LudoUtils.dataStore.getFromValidatorContainer(CurrentPage.ID),validation,fieldID);
				}
				if(String(fieldElement.@refresh)=="true")
				{
					ctlToRefresh.push([displayobject,fieldElement.@lookupsource]);
				}
				//check if readfrom when no value
				if(LudoUtils.getFieldValue(displayobject)=="" && defaultval!="")
				{
					LudoUtils.setFieldValueToSave(displayobject,defaultval);
					//LudoUtils.setFieldValue(displayobject,LudoUtils.getValueFromReadFrom(readfrom));
				}
			}
			//if(String(fieldElement.@requiredflag)=="true")
			if(requiredFlag)
			{
				frmItem.required=true;
			}
			var prop:String=String(fieldElement.@properties);
			if(ifProcessingPageReadOnly || readonly)
			{
				if(prop=="")
				{
					prop="enabled=false";
				}
				else if(prop.indexOf('enabled=false',0)==-1)
				{
					prop=prop+";enabled=false";
				}
			}
			//if(String(fieldElement.@properties)!="")
			if(prop.length>0)
			{
				LudoUtils.setFieldProperties(displayobject,prop);
			}
			return frmItem;
		}
		private function refreshControlOptions(pageid:String):void
		{
			for each(var ctls:Array in LudoUtils.pageController.getFromControlToRefreshContainer(pageid))
			{
				setArrayFormSource(ctls[1],ctls[0]);
				/*
				switch(LudoUtils.getFieldType(ctls[0]))//1st one controls
				{
					case 'CComboBox':
						(ctls[0] as CComboBox).dataProvider =optionArrayFormSource(ctls[1]);
						break;
					case 'ComboBox':
						(ctls[0] as ComboBox).dataProvider =optionArrayFormSource(ctls[1]);
						break;
					default:
						break
				}
				*/			
			}
		}
		public function PaintMainPageByID(pageid:String):void
		{
			CurrentPage.ID=pageid;
			paintAPage(pageid,"main");
		}
		/*
		public function PaintMessagePage(messageHeader:String,message:String):void
		{
			CurrentPage.ID='message';
			paintAPage('message',"main");
		}
		*/
		public function PaintRightPageByID(pageid:String):void
		{
			CurrentRightPage.ID=pageid;
			paintAPage(pageid,"right");
		}
		private function paintAPage(pageid:String,where:String="main"):void
		{
			var redraw:Boolean=false;
			ifProcessingPageReadOnly=LudoUtils.pageController.ifReadOnly(pageid);
			where=="right"?LudoUtils.pageController.emptyRightEntryBox():LudoUtils.pageController.emptyEntryBox();
			var screenXML:XML=where=="right"?rightscreenxml:screenxml;
			if(screenXML !=null)
			{
				//if the page is already generated
				//hide page message
				if(where!="right")
				{
					MessageController.hidePageErrorMsg();
				}
				var storedPage:Array=LudoUtils.pageController.pageContainer(pageid);
				//check if we need to redraw
				if(storedPage!=null)
				{
					if(!LudoUtils.pageController.ifPainted(pageid) || LudoUtils.pageController.redrawPage(pageid,String(screenXML.page.(@id == pageid).@redraw),String(screenXML.page.(@id == pageid).@redrawifquotein)))
					{
						where=="right"?LudoUtils.pageController.emptyRightPageContainer():LudoUtils.pageController.emptyCurrentPageContainer();
						storedPage=null
					}
				}
				//if(String(screenXML.page.(@id == pageid).@redraw)=="true" && storedPage!=null)
				/*
				if(LudoUtils.pageController.redrawPage(pageid,String(screenXML.page.(@id == pageid).@redraw),String(screenXML.page.(@id == pageid).@redrawifquotein)) && storedPage!=null)
				{
					where=="right"?LudoUtils.pageController.emptyRightPageContainer():LudoUtils.pageController.emptyCurrentPageContainer();
					storedPage=null;
				}
				*/
				if(storedPage==null)
				{
					redraw=true;
					var page:XMLList=screenXML.page.(@id == pageid);
					if(!LudoUtils.pageController.viewPageIfQuoteIn(String(page.@viewifquotein)))
					{
						return;
					}
					var dataEntryBox:DataEntryVBox=new DataEntryVBox();
					where=="right"?LudoUtils.pageController.dataEntryRightInnerBox=dataEntryBox:LudoUtils.pageController.dataEntryInnerBox=dataEntryBox;
					var units:Array=[];
					var dataMapArray:Array=[];
					var xmlMapArray:Array=[];
					var ctlToRefresh:Array=[];
					var coverageArray:Array=[];
					//create validation array
					//first one page validators, 2nd one validators by id, 3rd server validators
					LudoUtils.dataStore.addToValidatorContainer(pageid,[[],[],[]]);
					//create validation array
					LudoUtils.dataStore.addToObjectMapContainer(pageid,[]);
					//var validatorArray:Array=[];
					var initFunc:String=String(page.@initfunc);
					if(initFunc.length>0)
					{
						LudoUtils.dataStore.addToInitFuncContainer(pageid,LudoUtils.getFunctionReferenceByFullPath(initFunc));
					}
					if(String(page.@labelwidth)!="")
					{
						where=="right"?this.currentLabelWidth=page.@labelwidth:this.currentLabelWidth=page.@labelwidth;
					}
					else
					{
						where=="right"?this.currentLabelWidth=this.defaultRightLabelWidth:this.currentLabelWidth=this.defaultLabelWidth
					}
					if(String(page.@commonmenu) != "false")
					{
						page=screenXML.page.(@id == 'commonmenu')+page;
					}					
					if(String(page.@commontop) != "false")
					{
						page=screenXML.page.(@id == 'commontop')+page;
					}					
					if(String(page.@commonbottom) != "false")
					{
						page=page+screenXML.page.(@id == 'commonbottom');
					}					//width
					if(String(page.@width) != "")
					{
						dataEntryBox.width=page.@width;
						//pageinfo.entrybox.width=page.@width;
					}
					//page menu
					//header
					var pHeader:PageHeaders = new PageHeaders();
					pHeader.label=page.@title;
					dataEntryBox.addElement(pHeader);
					//dataEntryBox.addChild(pHeader);
					//add header id
					LudoUtils.pageController.addElmentByID(pageid,pageid+"_title",pHeader);
					//CurrentPage.addElmentByID(pageid+"_title",pHeader);

					//page message box
					//dataEntryBox.addChild(pageManager.pageMessageBox);
					//page tip
					if(String(page.@tip) != "")
					{
						var pagetip:TipBox = new TipBox();
						pagetip.styleName="pageTipBox";
						pagetip.tip=String(page.@tip);
						pagetip.icon="pagetip";
						dataEntryBox.addElement(pagetip);
						//dataEntryBox.addChild(pagetip);
					}
					//pageinfo.entrybox.addChild(pHeader);
					var pageElement:XMLList = page.panel;
					//smartquote.debug(pageElement
					var fieldType:String = "";
					for each (var n:XML in pageElement)
					{
						if(!LudoUtils.pageController.paintPanel(pageid,String(n.@viewifquotein)))
						{
							continue;
						}
						//var x:XMLList = n.children();
						var aPanel:*;
						var panelid:String=n.@id;
						var readOnlyPanel:Boolean=ifProcessingPageReadOnly;
						if(!readOnlyPanel)
						{
							readOnlyPanel=LudoUtils.pageController.readOnlyIfQuoteIn(String(n.@readonlyifquotein))
						}
						switch(String(n.@type).toLowerCase())
						{
							case 'actionbar':
								aPanel=new ActionBar();
							break;
							case 'pageactionbar'://only one page action bar allowed
								aPanel=new ActionBar();
								LudoUtils.pageController.setActionBar=aPanel;
							break;
							default:
								//aPanel= new DataEntryPanel();
								aPanel=new PanelBox();
							break;
						}				
						//dataEntryBox.addChild(aPanel);
						dataEntryBox.addElement(aPanel);
						if(String(n.@title) != "")
						{
							aPanel.title=n.@title;
						}
						if(String(n.@width) != "")
						{
							aPanel.width=n.@width;
						}
						aPanel.id=n.@id;
						if(String(n.@stylename) != "")
						{
							aPanel.styleName=n.@stylename;
						}
						else
						{
							aPanel.styleName="pageBlock";
						}
						if(String(n.@tip) != "")
						{
							var panelTip:TipBox = new TipBox();
							panelTip.styleName="panelTipBox";
							panelTip.tip=String(n.@tip);
							panelTip.icon="paneltip";
							aPanel.addElement(panelTip);
						}
						//check if this is a grid
						switch(String(n.@type))
						{
							case 'unitgrid':
								var _unitgrid:UnitEditGrid = new UnitEditGrid()
								_unitgrid.unitid=panelid;
								_unitgrid.pageid=pageid;
								var filter:String=String(n.@dataFilter);
								if(String(n.@xmlmap) != "")
								{
									var gridnode:XMLList= xmlMapper.getNodeByXpath(n.@xmlmap,String(n.@dataFilter));
									if(gridnode.length()<1 && filter!="")
									{
										//2nd try without filter
										gridnode=xmlMapper.getNodeByXpath(n.@xmlmap);
									}
									//still no node available
									if(gridnode.length()<1)
									{
										//create node
										gridnode=XMLList(xmlMapper.createXmlNodeByPathAtRoot(n.@xmlmap,String(n.@dataFilter)));
									}
									if(gridnode.length()>0)
									{
										//if filter
										_unitgrid.collection=gridnode;
										//_unitgrid.datacollection=gridnode;
									}
									else
									{
										throw new Error("Missing acord node !");
									}
									_unitgrid.unitMap=n.@xmlmap;
								}
								if(String(n.@identifier) != "")
								{
									_unitgrid.identifier=String(n.@identifier);
									_unitgrid.identifierFormat=String(n.@identifierformat);
								}
								else
								{
									throw new Error("Missing unit identifier !");
								}
								if(String(n.@firsttimedefaultsets) != "")
								{
									_unitgrid.firsttimedefaultsets=String(n.@firsttimedefaultsets);
								}
								_unitgrid.columncollections=Columns.createGridColumnArray(n.colElement,pageid);
								//add grid to panel							
								aPanel.addElement(_unitgrid);
								//check for unit
								var unitElement:XMLList = n.unit;
								for each (var unit:XML in unitElement)
								{
									//we are not allowing form items here under unit
									var unitMapArray:Array=[];
									var aUnitPanel:PanelBox = _unitgrid.paneltoadd;//new DataEntryPanel();
									//_unitgrid.entrypanel.addElement(aUnitPanel);
									if(String(unit.@title) != "")
									{
										aUnitPanel.title=unit.@title;
									}
									if(String(unit.@width) != "")
									{
										aUnitPanel.width=unit.@width;
									}
									var unitid:String=unit.@id;
									units.push(unitid);//add unit id here and then attached to page
									aUnitPanel.id=unitid;
									if(String(unit.@stylename) != "")
									{
										aUnitPanel.styleName=unit.@stylename;
									}
									
									//create a formItem to put in the form
									var uelement:XMLList=unitElement.fieldElement;
									for(var ucount:int = 0; ucount < uelement.length(); ucount++)
									{

										aUnitPanel.addElement(AddFormItem(pageid,uelement[ucount],"unit",readOnlyPanel,dataMapArray,unitMapArray,_unitgrid.coverageCtlArray,ctlToRefresh));
									}
									if(unitMapArray.length>0)
									{
										//hey here should be <pageid>_<unitid>
										LudoUtils.dataStore.addToUnitXmlMapContainer(pageid+"_"+unitid,[_unitgrid,unitMapArray]);
									}
									if(String(unit.@emptymessage) != "")
									{
										_unitgrid.emptymessage=unit.@emptymessage;
									}
								}
								break;
							/*
							case 'advancedisplaygrid':
								var grid:AdvancedDataGridView=new AdvancedDataGridView();
								grid.renderGrid(n);
								aPanel.addChild(grid);
								break;
							*/
							case 'displaygrid':
							case 'advancedisplaygrid':
								var _grid:CDataGrid;
								if(String(n.@type)=='advancedisplaygrid')
								{
									_grid = new DataViewGrid();
									_grid.columncollections=Columns.createGridColumnArray(n.colElement,pageid);
								}
								else
								{
									_grid = new DataViewGrid()
									_grid.columncollections=Columns.createGridColumnArray(n.colElement,pageid);
								}
								_grid.hideIfNoRow=LudoUtils.booleanValue(String(n.@hideifnorow));
								_grid.hideParentIfNoRow=LudoUtils.booleanValue(String(n.@hideifnorow));
								var filter2:String=String(n.@dataFilter);
								if(String(n.@xmlmap) != "")
								{
									var gridnode2:XMLList= xmlMapper.getNodeByXpath(n.@xmlmap,String(n.@dataFilter));
									if(gridnode2.length()<1 && filter2!="")
									{
										//2nd try without filter
										gridnode2=xmlMapper.getNodeByXpath(n.@xmlmap);
									}
									//still no node available
									if(gridnode2.length()<1)
									{
										//create node
										gridnode2=XMLList(xmlMapper.createXmlNodeByPathAtRoot(n.@xmlmap,String(n.@dataFilter)));
									}
									if(gridnode2.length()>0)
									{
										//if filter
										_grid.datacollection=gridnode2;
									}
									else
									{
										throw new Error("Missing acord node !");
									}
								}
								else if(String(n.@datamap) != "")
								{
									BindingUtils.bindProperty(_grid,"datacollection",LudoUtils.modelController.collections,String(n.@datamap).split('.'));
									//_grid.datacollection=LudoUtils.getObjectFromChain(LudoUtils.modelController.collections,String(n.@datamap)) as XMLList;
									//LudoUtils.setBindProperty(_grid.datacollection,LudoUtils.modelController.collections,String(n.@datamap));
								}
								if(String(n.@hideheader)=='true')
								{
									_grid.showHeaders=false;
								}
								//_grid.resizeGrid(_grid.datacollection.length());
								//_grid.resetGrid();
								aPanel.addElement(_grid);
								break;
							default:
								var x:XMLList=n.fieldElement;
								for(var j:int = 0; j < x.length(); j++)
								{
									aPanel.addElement(AddFormItem(pageid,x[j],"form",readOnlyPanel,dataMapArray,xmlMapArray,coverageArray,ctlToRefresh));
								}
								break;
						}
						//dataEntryBox.addChild(aPanel);	
					}
					where=="right"?LudoUtils.pageController.addToRightPage(dataEntryBox):LudoUtils.pageController.addToCurrentPage(dataEntryBox);
					//LudoUtils.pageController.addToCurrentPage(dataEntryBox);
					//page is painted
					LudoUtils.pageController.paintedPage=pageid;
					LudoUtils.dataStore.addToDataMapContainer(pageid,dataMapArray);
					LudoUtils.dataStore.addToXmlMapContainer(pageid,xmlMapArray);
					LudoUtils.dataStore.addToPageContainer(pageid,[dataEntryBox,units]);
					LudoUtils.dataStore.addToCoverageContainer(pageid,coverageArray);
					LudoUtils.pageController.addToControlToRefreshContainer(pageid,ctlToRefresh);
				}
				else
				{
					if(storedPage[0]!=null)
					{
						//where=="right"?LudoUtils.pageController.dataEntryRightInnerBox=storedPage[0]:LudoUtils.pageController.dataEntryInnerBox=storedPage[0];
						where=="right"?LudoUtils.pageController.dataEntryRightInnerBox=dataEntryBox:LudoUtils.pageController.dataEntryInnerBox=storedPage[0];
						where=="right"?LudoUtils.pageController.addToRightPage(storedPage[0]):LudoUtils.pageController.addToCurrentPage(storedPage[0]);
						//LudoUtils.pageController.addToCurrentPage(storedPage[0]);
						LudoUtils.pageController.resetUnitInPage(pageid);
						refreshControlOptions(pageid);
					}
				}
				//execute pageinit function if any
				var initFuncToCall:Function=LudoUtils.dataStore.getFromInitFuncContainerContainer(pageid);
				if(initFuncToCall!=null)
				{
					initFuncToCall.call(this);
				}
				//execute pageinit script if any
				var script:String =screenXML.page.(@id == pageid).pageinitscript;
				if(script.length>0)
				{
					D.eval(script);
				}
				if(where!="right" && LudoUtils.pageController.hasRightPage)
				{
					var rightpageid:String=String(screenXML.page.(@id == pageid).@rightpageid);
					if(rightpageid=="")
					{
						rightpageid=LudoUtils.pageController.rightDefaultPage;
					}
					if(rightpageid!=CurrentRightPage.ID)
					{
						CurrentRightPage.ID=rightpageid;
						PaintRightPage();
					}
				}
			}
		}
		public function PaintPage():void
		{
			paintAPage(CurrentPage.ID,"main");
		}
		public function PaintRightPage():void
		{
			paintAPage(CurrentRightPage.ID,"right");
		}

//end paint page
	}
}