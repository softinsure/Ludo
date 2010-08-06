/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: GridColumnButton.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	
	import flash.sampler.NewObjectSample;
	
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	
	import org.ludo.components.mxml.DynaCheckBox;

	public class GridColumnCheckBox extends CustomGridColumn
	{
		public function GridColumnCheckBox(columnInfo:XML,pageid:String="")
		{
			super(columnInfo,pageid);
			var	selectifvalueis:String=String(columnInfo.@selectifvalueis);
			var	columnName:String=String(columnInfo.@datafield);
			var	labelfield:String=String(columnInfo.@labelfield);
			var parentFunc:String=String(columnInfo.@method);
			var funcParam:String=String(columnInfo.@methodparam);
			var boxStyle:String=String(columnInfo.@stylename);
			var modelclasspath:String=String(columnInfo.@modelclasspath);
			var paramArray:Array;
			var factory:ClassFactory;
			if(String(columnInfo.@methodparam)!="")
			{
				paramArray=columnInfo.@methodparam.split(",");
			}
			else
			{
				paramArray=[];
			}
			if(parentFunc=="")
			{
				parentFunc="org.ludo.controllers.ActionController.modelGridCheckBoxClicked";//hardcoded
			}
			if(modelclasspath!="")
			{
				paramArray.unshift(modelclasspath);//first is model path
			}
			if(String(columnInfo.@methodparam)!="")
			{
				paramArray=columnInfo.@methodparam.split(",");
			}
			else
			{
				paramArray=[];
			}
			factory = new ClassFactory(DynaCheckBox);
			factory.properties={label:String(columnInfo.@label),setParameters:[columnName,selectifvalueis,parentFunc,paramArray,labelfield,boxStyle]};
			this.itemRenderer = factory;
		}
		override public function itemToLabel(data:Object):String
		{
			this.itemRenderer.newInstance();
			return super.itemToLabel(data);
		}
	}	 
}
