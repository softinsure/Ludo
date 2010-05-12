/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: ImageAsButton.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	
	import org.common.utils.XArrayUtil;
	import org.ludo.connectors.ImageConnector;
	import org.ludo.utils.LudoUtils;
	
	public class ImageAsButton extends Image
	{
		private var parentFunction:Function;
		private var parentDataField:String;
		private var funtionParam:Array;
		public function ImageAsButton(imagename:String,styleName:String="")
		{
			this.source=ImageConnector.getImageByName(imagename);
			if(styleName!="")
			{
				this.styleName=styleName;
			}
			else
			{
				this.styleName="imgageAsButton";
			}
			this.useHandCursor=true;
			this.buttonMode=true;
			this.addEventListener(MouseEvent.CLICK,imageClicked);
		}
		public function set setParentFunction(func:Function):void
		{                                                                   
         	parentFunction = func;
     	}
		public function set setFunctionParamn(param:Array):void {                                                                   
         funtionParam = param;
     	}
		public function set setParentFunctionByName(func:String):void {                                                                   
			if(func!="")
			{
				parentFunction = LudoUtils.getFunctionReferenceByFullPath(func);
			}
		}
		public function imageClicked(event:Event):void
		{
			if(parentFunction!=null)
			{
				if(funtionParam!=null && funtionParam.length>0)
				{
					
					//parentFunction(event,funtionParam);
					parentFunction.apply(this,XArrayUtil.concat(event,funtionParam));
				}
				else
				{
					parentFunction(event);
				}				
			}    
		}
	}
}
