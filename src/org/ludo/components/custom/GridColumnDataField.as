/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: GridColumnDataField.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.XMLMapper;
	public class GridColumnDataField extends CustomGridColumn
	{
		private var lookupsource:String="";
		public function GridColumnDataField(columnInfo:XML,pageid:String="")
		{
			super(columnInfo,pageid);
			this.lookupsource=columnInfo.@lookupsource;
		}
		override public function itemToLabel(data:Object):String
		{
			var label:String="";				
			if(data==null)
			{
				//Resume normal behaviour
				return super.itemToLabel(data);	
			}
			else if(data is XML)
			{
				label=LudoUtils.getNodeValue(XMLMapper.getNodeByXpathAndRootNode(data as XML,dataField)[0]);
			}
			else//conventional
			{
				var fields : Array;
				var attribute : String;
				var dataFieldSplit : String = dataField;
				var currentData : Object = data;
				if(dataField.indexOf("@") != - 1)
				{
					fields = dataFieldSplit.split("@");
					dataFieldSplit = fields[0];
					attribute = fields[1];
				}
	
				if(dataField.indexOf(".") != - 1)
				{
					fields = dataFieldSplit.split(".");
					for each(var f : String in fields)
						currentData = currentData[f];
					if(currentData is String)
						return String(currentData);
				}else
				{
					if(dataFieldSplit != "")
						currentData = currentData[dataFieldSplit];
				}
	
				if(attribute)
				{
					if(currentData is XML || currentData is XMLList)
						currentData = XML(currentData).attribute(attribute);
					else  
						currentData = currentData[attribute];
				}
	
				try
				{
					label = currentData.toString();
				}
	
				catch(e : Error)
				{
					label = super.itemToLabel(data);
				}
				
			}
			//check if from lookup source
			if(this.lookupsource!="")
			{
				label=LudoUtils.lookupSource.getValueFromLookupSource(this.lookupsource,label);
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
