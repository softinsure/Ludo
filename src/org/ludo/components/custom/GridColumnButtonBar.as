/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: GridColumnButtonBar.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	
	import org.ludo.components.mxml.DynaButtonBar;
	import org.ludo.components.mxml.DynaLabelButtonBar;
	import org.ludo.components.mxml.DynaLinkButtonBar;
	import org.ludo.utils.LudoUtils;

	public class GridColumnButtonBar extends CustomGridColumn
	{
		public function GridColumnButtonBar(columnInfo:XML,pageid:String)
		{
			super(columnInfo,pageid);
			var type:String=String(columnInfo.@buttontype);
			var	columnName:String=String(columnInfo.@datafield);
			var btnArray:XMLList=LudoUtils.filterByViewMode(columnInfo.object,pageid);
			var parentFunc:String=String(columnInfo.@method);
			var funcParam:String=String(columnInfo.@methodparam);
			var buttonStyle:String=String(columnInfo.@stylename);
			var modelclasspath:String=String(columnInfo.@modelclasspath);
			var paramArray:Array;
			if(String(columnInfo.@methodparam)!="")
			{
				paramArray=columnInfo.@methodparam.split(",");
			}
			else
			{
				paramArray=[];
			}
			if(modelclasspath!="")
			{
				if(parentFunc=="")
				{
					parentFunc="org.ludo.controllers.ActionController.modelGridButtonBarClicked";//hardcoded
				}
				paramArray.unshift(modelclasspath);//first is model path
			}
			var factory:ClassFactory;
			switch(type.toLowerCase())
			{
				case 'label':
					factory= new ClassFactory(DynaLabelButtonBar);
					factory.properties={pageid:pageid,setBtnArray:[columnName,btnArray,parentFunc,paramArray,buttonStyle]};
					break;
				case 'link':
					factory= new ClassFactory(DynaLinkButtonBar);
					factory.properties={pageid:pageid,setBtnArray:[columnName,btnArray,parentFunc,paramArray,buttonStyle]};
					break
				default:
					factory= new ClassFactory(DynaButtonBar)
					factory.properties={pageid:pageid,setBtnArray:[columnName,btnArray,parentFunc,paramArray,buttonStyle]};
					break
			}			
			//var factory:ClassFactory = new ClassFactory(DynaButtonBar);
			this.itemRenderer = factory;
			if(String(columnInfo.@properties)!="")
			{
				LudoUtils.setObjectProperties(this,columnInfo.@propertie);
			}
		}
	}	 
}
