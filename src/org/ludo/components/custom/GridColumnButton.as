/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: GridColumnButton.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	
	import org.ludo.components.mxml.DynaButton;

	public class GridColumnButton extends CustomGridColumn
	{
		public function GridColumnButton(columnInfo:XML,pageid:String="")
		{
			super(columnInfo,pageid);
			var paramArray:Array;
			if(String(columnInfo.@methodparam)!="")
			{
				paramArray=columnInfo.@methodparam.split(",");
			}
			else
			{
				paramArray=[];
			}
			var factory:ClassFactory = new ClassFactory(DynaButton);
			factory.properties={label:String(columnInfo.@label),setParentFunctionByName:String(columnInfo.@method),setFunctionParamn:paramArray};
			this.itemRenderer = factory;
		}
	}	 
}
