/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: CoverageInput.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.FormItem;
	import mx.controls.Text;
	
	import org.common.utils.XStringUtil;
	import org.ludo.components.mxml.*;
	import org.ludo.utils.Acord;
	import org.ludo.utils.FormBuilder;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.XMLMapper;
	import org.ludo.views.UnitEditGrid;
	
	public class CoverageInput extends FormItem
	{
		//private var limit:CComboBox = new CComboBox();
		//private var deductiblelimit:CComboBox = new CComboBox();
		private var limit:CDropDownList = new CDropDownList();
		private var deductiblelimit:CDropDownList = new CDropDownList();
		private var deductiblevalue:CTextInput = new CTextInput();
		private var value:CTextInput = new CTextInput();
		private var limit1:CTextInput = new CTextInput();
		private var limit2:CTextInput = new CTextInput();
		private var deductible:CTextInput = new CTextInput();
		private var coveragelabel:Text = new Text();
		private var coveragecode:String;
		private var coveragenode:XML;
		private var coveragelookup:XML;
		//private var blankcoveragenode:XMLList;
		private var blankcoveragenode:XML;
		private  var allunitnodes:XMLList;
		private  var parentnode:XML;
		private var coveragetag:XML;
		private var coveragelevel:String="policy";
		private var currentFieldMapping:Array;
		private var unitmap:String="";
		private var parenttype:String="unit";
		//private var nodechanged:Boolean=false;
		//private var parentgrid:UnitEditGrid;
		private var lblwidth:int=200;
		private var itemarray:Array=[];
		private var pageid:String;
		private var properties:String="";
		private var requiredFlag:Boolean=false;
		protected var ID:String="";
		private var attachedToUnitPanel:UnitEditGrid;
		
		public function CoverageInput(pageid:String,coverageTag:XML,parentType:String="unit",readonly:Boolean=false)
		{
			this.coveragetag=coverageTag;
			//get the code before crating coverage node	
			if(String(coveragetag.@coveragecode)!="")
			{	
				this.coveragecode=coveragetag.@coveragecode;
			}
			else
			{
				throw new Error("Missing coverage code !");
			}
			ID=String(coverageTag.@id);
			if(ID=="") ID=this.coveragecode;
			properties=String(coverageTag.@properties);
			if(readonly||LudoUtils.pageController.ifReadOnly(pageid))
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
			this.pageid=pageid;
			//var id:String=String(coverageTag.@id);
			lblwidth=FormBuilder.getInstance().labelWidth;
			
			//parent type
			this.parenttype=parentType;
			//create a blanknode
			blankcoveragenode=(Acord.getAcordTag("coverage") as XML).copy();
			//this.parentgrid=unitGrid;
			this.direction="horizontal";
			//coverage tag
			requiredFlag=LudoUtils.pageController.requiredField(pageid,coveragetag);
			this.required=requiredFlag;
			//validation array
			//var vArray:Array=LudoUtils.dataStore.getFromValidatorContainer(pageid);
			//parent unit xmlmap
			this.unitmap=String(coveragetag.@unitxmlmap);
			//reser field mapping array
			this.currentFieldMapping=[];
			coveragelookup=LudoUtils.lookupSource.getCoverageLookup(coveragecode);
			if(coveragelookup==null)
			{
				throw new Error("Missing coverage entry in coverage lookupfor code "+coveragecode+"!");
			}
			//here is the coverage description
			if(coveragelookup.hasOwnProperty("description"))
			{
				coveragelabel.text=coveragelookup.description;
			}			
			else
			{
				coveragelabel.text="Missing Label";
			}
			//check if this is a policy or unit level
			if(coveragelookup.hasOwnProperty("level"))
			{
				this.coveragelevel=coveragelookup.level;
				if(this.coveragelevel=="ALL")
				{
					this.coveragelevel="policy";
				}
			}			
			else
			{
				this.coveragelevel="policy";
			}
			//fixed length--will work on later
			coveragelabel.width=lblwidth;			
			this.addChild(coveragelabel);
			if(coveragelookup.hasOwnProperty("limit"))
			{
				this.addChild(limit);
				this.limit.dataProvider=LudoUtils.lookupSource.optionArray(String(coveragelookup.limit.@lookupsource));
				var lval:String=getValidation(coveragelookup.limit.@validation);
				if(lval!="")
				{
					LudoUtils.pageController.addValidationToPage(pageid,this.limit,lval,ID+"_limit");
				}				
				//docurrent field mapping
				//limit1
				addToItemArray(this.limit1,'Limit/FormatInteger',0);
				addToItemArray(this.limit2,'Limit/FormatInteger',1);
				limit.addEventListener(Event.CHANGE,onChangeLimit);
			}
			if(coveragelookup.hasOwnProperty("value"))
			{
				this.addChild(value);
				var vval:String=getValidation(coveragelookup.value.@validation);
				if(vval!="")
				{
					LudoUtils.pageController.addValidationToPage(pageid,this.value,vval,ID+"_value");
				}
				addToItemArray(this.limit1,'Limit/FormatInteger',0);
				value.addEventListener(Event.CHANGE,onChangeValue);
			}
			if(coveragelookup.hasOwnProperty("deductible"))
			{
				if(String(coveragelookup.deductible.@type)=="value")
				{
					this.addChild(deductiblevalue);
					var dval:String=getValidation(coveragelookup.deductible.@validation);
					if(dval!="")
					{
						LudoUtils.pageController.addValidationToPage(pageid,this.deductiblevalue,dval,ID+"_deductiblevalue");
					}
					deductible.addEventListener(Event.CHANGE,onChangedeductible);
				}
				else
				{
					this.addChild(deductiblelimit);
					this.deductiblelimit.dataProvider=LudoUtils.lookupSource.optionArray(String(coveragelookup.deductible.@lookupsource));
					var dlval:String=getValidation(coveragelookup.deductiblelimit.@validation);
					if(dlval!="")
					{
						LudoUtils.pageController.addValidationToPage(pageid,this.deductiblelimit,dlval,ID+"_deductiblelimit");
					}
					deductiblelimit.addEventListener(Event.CHANGE,onChangedeductible);
				}
				addToItemArray(this.deductible,'Deductible/FormatInteger');
			}
			//set the coverage node
			setCoverageNode();
			setID();
			setProperties();
		}
		private function getValidation(validation:String):String
		{
			if(requiredFlag)
			{
				if(properties.indexOf('required=true',0)==-1)
				{
					//add validation
					validation=(validation!=""?validation+";":"default|")+"required=true";
				}
				
			}
			return validation;
		}
        public function set showControls(show:Boolean):void
        {
        	this.limit.visible=show;
        	this.value.visible=show;
        	this.deductiblelimit.visible=show;
        	this.deductiblelimit.visible=show;
    	}
 		private function addElmentByID(id:String,obj:*):void
		{
			if(id.length>0)
			{
				obj["id"]=id;
				LudoUtils.pageController.addElmentByID(pageid,id,obj);
			}
		}
		private function setID():void {
			if(ID!="")
			{
				addElmentByID(ID+"_limit",this.limit);
				addElmentByID(ID+"_limit1",this.limit1);
				addElmentByID(ID+"_limit2",this.limit2);
				addElmentByID(ID+"_deductiblelimit",this.deductiblelimit);
				addElmentByID(ID+"_deductiblevalue",this.deductiblevalue);
				addElmentByID(ID+"_value",this.value);
				addElmentByID(ID+"_deductible",this.deductible);
				addElmentByID("lbl_"+ID,this.coveragelabel);
				addElmentByID("parent_"+ID,this);
			}
		}		
	  	private function setProperties():void 
	  	{
	  		if(properties.length>0)
	  		{
				LudoUtils.setFieldProperties(this.limit,properties);
	  			LudoUtils.setFieldProperties(this.limit1,properties);
	  			LudoUtils.setFieldProperties(this.limit2,properties);
	  			LudoUtils.setFieldProperties(this.deductiblelimit,properties);
	  			LudoUtils.setFieldProperties(this.deductiblevalue,properties);
	  			LudoUtils.setFieldProperties(this.value,properties);
	  			LudoUtils.setFieldProperties(this.deductible,properties);
	  		}
		}
       	private function onChangeLimit(event:Event):void
		{
			this.limit1.text="";
			this.limit2.text="";
			var limitArray:Array=this.limit.selectedValue.split("/");
			if(limitArray.length>0)
			{
				this.limit1.text=limitArray[0];
			}
			if(limitArray.length>1)
			{
				this.limit2.text=limitArray[1];
			}
		}
		private function onChangeValue(event:Event):void
		{
			this.limit1.text=value.text;
		}
		private function onChangedeductible(event:Event):void
		{
			if(String(coveragelookup.deductible.@type)=="value")
			{
				this.deductible.text=this.deductiblevalue.text;
				
			}
			else
			{
				this.deductible.text=this.deductiblelimit.selectedValue;
			}
		}
		public function setAllUnits(allunits:XMLList):void
		{
			this.allunitnodes=allunits;
		}
		public function resetControl(unitPanel:UnitEditGrid,newunit:Boolean=false):void
		{
			//nodechanged=false;
			this.attachedToUnitPanel=unitPanel;
			var parent:XML=attachedToUnitPanel.currentNode;
			if(coveragelevel=="policy" && newunit)
			{
				//get the coverage node from first unit
				this.parentnode=allunitnodes[0] as XML;
			}
			else
			{
				this.parentnode=parent;
			}
			this.coveragenode=getCoverageNode();
			this.parentnode=parent;
			doFieldMapping();
		}
		private function addToItemArray(formitem:DisplayObject,xpath:String,nodeposition:int=0):void
		{
			var obj:Object=new Object();
			obj.formitem=formitem;
			obj.xpath=xpath;
			obj.nodeposition=nodeposition;
			itemarray.push(obj);
		}
		private function setCoverageNode():void
		{
			//check if parent unit grid available
			//parent unitgrid is created first and then attached to the coverage
			if(unitmap!="")//get from unit map, here this must be policy level coverage
			{
				allunitnodes=LudoUtils.modelController.xmlMapper.getNodeByXpath(unitmap);
			}
			if(parenttype!="unit")
			{
				coveragelevel="policy";
				if(allunitnodes!=null)//policy level and has parent to attach coverage
				{
					this.parentnode=allunitnodes[0] as XML;//first node as all wiil have same coverage
					this.coveragenode=getCoverageNode();
					doFieldMapping();				
				}				
			}
		}
		private function getCoverageNode():XML
		{
			var xpath:String="Coverage[CoverageCd='"+coveragecode+"']"
			//check if coverage is already added
			var node:XML=XMLMapper.getNodeByXpathAndRootNode(parentnode,xpath)[0];
			if(node==null)//not added then copy from blank node
			{
				//currentnodelist=(blankcoveragenode[0] as XML).copy();
				//var nodelist:XMLList=new XMLList((blankcoveragenode[0].Coverage[0] as XML).copy());
				//get from blank node
				node=XMLMapper.getNodeByXpathAndRootNode(XMLList(XML(blankcoveragenode.Coverage[0]).copy())[0],"Coverage")[0];
				//var node2:XML=blankcoveragenode.copy();
				node["CoverageCd"]=coveragecode;
				//node.@id='Coverage_'+coveragelevel+"_"+coveragecode+"_";
				node["EffectiveDt"]=LudoUtils.modelController.quote.policy_effective_date;
			}
			return node.copy();
		}
		private function doFieldMapping():void
		{
			currentFieldMapping=[];
			for each (var item:Object in itemarray)
			{
				var nodeList:XMLList=XMLMapper.getNodeByXpathAndRootNode(this.coveragenode,String(item.xpath));
				if(nodeList.length()<=0)//try again
				{
					nodeList=XMLMapper.getNodeByXpathAndRootNode(this.coveragenode,String('Coverage/'+item.xpath));
				}
				var node:XML;
				if(nodeList.length()>int(item.nodeposition))
				{
					node=nodeList[int(item.nodeposition)];
				}
				this.currentFieldMapping.push([item.formitem,node,item.xpath,item.nodeposition]);
				LudoUtils.setNodeValueToField(item.formitem,node);
			}
			if(coveragelookup.hasOwnProperty("limit"))
			{
				var lmt1:String=limit1.text;
				var lmt2:String=limit2.text;
				if(lmt1!="0" && lmt1!="" && lmt2!="0" && lmt2!="")
				{
					limit.selectedValue=lmt1+"/"+lmt2;
				}
				else if(lmt1!="0" && lmt1!="")
				{
					limit.selectedValue=lmt1;
				}
				else
				{
					limit.selectedValue="";
				}
			}
			if(String(coveragelookup.deductible.@type)=="value")
			{
				this.deductiblevalue.text=this.deductible.text;			
			}
			else
			{
				this.deductiblelimit.selectedValue=this.deductible.text;
			}
		}
		public function anyValueChanged():Boolean
		{
			for each (var arr:Array in currentFieldMapping)
			{
				if(valueChanged(arr[0]))
				{
					return true;
				}
			}
			return false;
		}
		private function valueChanged(formitem:DisplayObject):Boolean
		{
			if(LudoUtils.getFieldValue(formitem)!=LudoUtils.getFieldValueBeforeSave(formitem))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		private function resetItem(formitem:DisplayObject):void
		{
			if(LudoUtils.getFieldValue(formitem)!=LudoUtils.getFieldValueBeforeSave(formitem))
			{
				LudoUtils.setFieldValue(formitem,LudoUtils.getFieldValueBeforeSave(formitem));
			}
		}
		private function checkBlankValue():Boolean
		{
			if(limit.selectedValue=="" && value.text=="" && deductible.text=="")
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		private function getCoverageNodeToUpdate(parentNode:XML):XML
		{
			var xpath:String="Coverage[CoverageCd='"+coveragecode+"']";
			var nodeList:XMLList=XMLMapper.getNodeByXpathAndRootNode(parentNode,xpath);
			if(nodeList[0]==null)//try blank id node
			{
				xpath="Coverage[CoverageCd='']";
				nodeList=XMLMapper.getNodeByXpathAndRootNode(parentNode,xpath);				
			}
			if(nodeList.length()>1)//delete excess nodes
			{
				LudoUtils.keepFirstNodeInXmlList(nodeList);
			//	delete nodeList[0];
			}
			return nodeList[0];		
		}
		private function getInsertAfterNode(parentNode:XML):XML
		{
			var xpath:String="Coverage";
			var nodeList:XMLList=XMLMapper.getNodeByXpathAndRootNode(parentNode,xpath);
			if(nodeList.length()>0)//delete excess nodes
			{
				return nodeList[nodeList.length()-1];	
			}
			else
			{
				return null;
			}
				
		}
		public function resetCoverageValue():void
		{
			for each (var arr:Array in currentFieldMapping)
			{
				resetItem(arr[0]);
			}			
		}
		private function get unitIdentifier():String
		{
			if(this.parenttype=='unit')
			{
				return attachedToUnitPanel.currentIdetifier;
			}
			return "";
		}
		private function get currentUnitMap():String
		{
			if(this.parenttype=='unit')
			{
				return attachedToUnitPanel.unitMap;
			}
			return this.unitmap;
		}
		public function doSaveCoverageNode():Boolean
		{
			var nodechanged:Boolean=false;
			var nocoverage:Boolean=checkBlankValue();
			if(nocoverage)
			{
				for each (var arr2:Array in currentFieldMapping)
				{
					if(valueChanged(arr2[0]))
					{
						var val2:String=LudoUtils.getFieldValue(arr2[0]);
						if(LudoUtils.pageController.changeDetail)
						{
							//addd to change detail
							LudoUtils.pageController.addToChangeDetail(arr2[0].id, pageid,"D",unitIdentifier,coveragelabel.text,"coverage",LudoUtils.getFieldValueBeforeSave(arr2[0]),val2,currentUnitMap+"Coverage[CoverageCd='"+coveragecode+"']/"+arr2[2]+"_"+arr2[3]);
						}
						nodechanged=true;
					}
				}
			}
			else
			{
				for each (var arr:Array in currentFieldMapping)
				{
					if(valueChanged(arr[0]))
					{
						var val:String=LudoUtils.getFieldValue(arr[0]);
						if(LudoUtils.pageController.changeDetail)
						{
							//addd to change detail
							LudoUtils.pageController.addToChangeDetail(arr[0].id, pageid,"M",unitIdentifier,coveragelabel.text,"coverage",LudoUtils.getFieldValueBeforeSave(arr[0]),val,currentUnitMap+"Coverage[CoverageCd='"+coveragecode+"']/"+arr[2]+"_"+arr[3]);
						}
						LudoUtils.setFieldValueToNode(arr[1],val);
						LudoUtils.setFieldValueBeforeSave(arr[0],val);
						nodechanged=true;
					}
				}
			}
			if(nodechanged)//value changed
			{
				//update all nodes if policy level
				var nodeList:XMLList;
				var insertAfterNode:XML;
				var nodetoupdate:XML;
				var xpath:String="Coverage[CoverageCd='"+coveragecode+"']"
				var coveragenodetoadd:XML=this.coveragenode.copy();
				//xpath="Coverage[@id='Coverage_"+coveragelevel+"_"+coveragecode+"_']";
				if(coveragelevel=='policy')
				{
					for each (var node:XML in allunitnodes)
					{
						//var unitseq:String=XStringUtil.lpad(node.childIndex(),3,"0")
						nodetoupdate=getCoverageNodeToUpdate(node);
						//nodeList=XMLMapper.getNodeByXpathAndRootNode(node,xpath);
						/*
	    				if(nodeList.length()>1)
	    				{
	    					Common.keepFirstNodeInXmlList(nodeList);
	    				//	delete nodeList[0];
	    				}
	    				*/
	    				if(nocoverage)
	    				{
	    					if(nodetoupdate!=null)
	    					{
	    						delete nodetoupdate.parent().children()[nodetoupdate.childIndex()];
	    					}
	    				}
	    				else
	    				{
	    					if(nodetoupdate==null)//not added then copy from blank node
							{
								insertAfterNode=getInsertAfterNode(node);
								if(insertAfterNode!=null)
								{
									//node.insertChildAfter(insertAfterNode,this.coveragenode.copy());
									node.insertChildAfter(insertAfterNode,coveragenodetoadd);
								}
								else
								{
									//node.appendChild(this.coveragenode.copy());
									node.appendChild(coveragenodetoadd);
								}
							}
							else
							{
								nodetoupdate.parent().children()[nodetoupdate.childIndex()]=coveragenodetoadd;
								//nodetoupdate.parent().children()[nodetoupdate.childIndex()]=this.coveragenode.copy();
							}
							//nodetoupdate.@id='Coverage_'+utils.lpad(node.childIndex(),3,"0")+"_"+coveragecode+"_";
	    				}
	    			}
				}
				else
				{
					nodetoupdate=getCoverageNodeToUpdate(parentnode);
					//nodeList=XMLMapper.getNodeByXpathAndRootNode(parentnode,xpath);
					/*
    				if(nodeList.length()>1)
    				{
    					Common.keepFirstNodeInXmlList(nodeList);
    				//	delete nodeList[0];
    				}
    				*/
    				if(nocoverage)
    				{
    					if(nodetoupdate!=null)
    					{
    						delete nodetoupdate.parent().children()[nodetoupdate.childIndex()];
    					}
    				}
    				else
    				{
    					if(nodetoupdate==null)//not added then copy from blank node
						{
							insertAfterNode=getInsertAfterNode(parentnode);
							if(insertAfterNode!=null)
							{
								//parentnode.insertChildAfter(insertAfterNode,this.coveragenode.copy());						
								parentnode.insertChildAfter(insertAfterNode,coveragenodetoadd);						
							}
							else
							{
								//parentnode.appendChild(this.coveragenode.copy());
								parentnode.appendChild(coveragenodetoadd);
							}
						}
						else
						{
							//nodetoupdate.parent().children()[nodetoupdate.childIndex()]=this.coveragenode.copy();
							nodetoupdate.parent().children()[nodetoupdate.childIndex()]=coveragenodetoadd;
						}
    				}
				}
				//blank premium
				//XMLMapper.setValueToNode(XMLMapper.getNodeByXpathAndRootNode(coverage,"CurrentTermAmt/Amt")[0],prem.toString());
				if(nodechanged && !nocoverage && coveragenodetoadd !=null)
				{
					XMLMapper.setValueToNode(XMLMapper.getNodeByXpathAndRootNode(coveragenodetoadd,"CurrentTermAmt/Amt")[0],'');
				}
			}
			return nodechanged;
		}
	}
}