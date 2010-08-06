/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: CustomGridColumn.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import mx.controls.dataGridClasses.DataGridColumn;
	
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.LudoUtils;

	public class CustomGridColumn extends DataGridColumn
	{
		public var pageid:String="";
		public function CustomGridColumn(columnInfo:XML,pageid:String)
		{
			if(pageid=="")
			{
				pageid=CurrentPage.ID;
			}
			this.pageid=pageid;
			super(String(columnInfo.@datafield));
			(String(columnInfo.@sortable)=='true')?this.sortable=true:this.sortable=false;
           	(String(columnInfo.@resizable)=='false')?this.resizable=false:this.resizable=true;
           	(String(columnInfo.@editable)=='true')?this.editable=true:this.editable=false;
           	(String(columnInfo.@visible)=='false')?this.visible=false:this.visible=true;
           	(String(columnInfo.@wordrap)=='false')?this.wordWrap=false:this.wordWrap=true;
           	if(String(columnInfo.@header) != "")
			{
            	this.headerText=columnInfo.@header;
            }
            else
            {
            	this.headerText=columnInfo.@datafield;
           	}
            if(String(columnInfo.@width) != "")
			{
            	this.width=columnInfo.@width;
            }
            if(String(columnInfo.@properties)!="")
			{
				LudoUtils.setObjectProperties(this,columnInfo.@propertie);
			}
			if(String(columnInfo.@labelFunction)!="")
			{
				this.labelFunction=LudoUtils.getFunctionReferenceByFullPath(columnInfo.@labelFunction);
			}
			headerWordWrap=true;
		}
		override public function itemToLabel(data:Object):String
		{
			var label:String=super.itemToLabel(data);
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