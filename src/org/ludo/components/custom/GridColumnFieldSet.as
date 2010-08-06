/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: GridColumnFieldSet.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.XMLMapper;
	public class GridColumnFieldSet extends CustomGridColumn
	{
		//private var sourceData:XMLList;
		private var labelFields:XMLList;
		private var joinpath:String="";//this path indicates to get value using this xpath from workitem(acord), default to datagrid
		private var jointoid:String="";//this must be when joinpath is defined, this will use to get the row from xmllist
		private var getvalpath:String="";//will be collected from datagrid, bydefault this is datafield
		public function GridColumnFieldSet(columnInfo:XML,pageid:String="")
		{
			super(columnInfo,pageid);
			this.sortable=false;
            var source:Array = String(columnInfo.@fieldset).split("::");
			if(source.length>=1)
			{
				//get the labelFields
				//first element is the fieldset id
				//collect from lookup source
				this.labelFields=LudoUtils.lookupSource.getFieldSets(source[0]).children();
				if(source.length>=3)//you have join path and key
				{
					this.joinpath=source[1];//joinpath
					this.jointoid=source[2];//join key
				}
				if(source.length>3)//you have path to get key value
				{
					this.getvalpath=source[3];//joinpath
				}
			}
		}

		override public function itemToLabel(data : Object) : String
		{
			if(data==null)
			{
				return "";
			}
			var label:String="";
			var sourceXml:XML;
			if(joinpath=="")
			{
				sourceXml=XMLList(data)[0];
			}
			else
			{
				//get from join path
				//create a joid condition
				if(this.jointoid!="")
				{
					//get the join value
					var val:String=LudoUtils.getNodeValue(XMLMapper.getNodeByXpathAndRootNode(data as XML,getvalpath==""?dataField:getvalpath)[0]);
					//sourceXml=XMLMapper.getNodeByXpathAndRootNode(sourceData.parent(),this.joinpath+"[@"+this.jointoid+"='"+val+"']")[0];
					sourceXml=LudoUtils.modelController.xmlMapper.getNodeByXpath(this.joinpath+"[@"+this.jointoid+"='"+val+"']")[0];
				}
				else
				{
					throw new Error("Mising filter condition (joinid) in fieldset attribute 'fieldsetid::joinpath::joinid::joinvalue'");
				}
			}
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
			//check label function
			if(this.labelFunction!=null)
			{
				return labelFunction(label,data,dataField);
			}
			else
			{
				return label;
			}			
		}
	}
}
