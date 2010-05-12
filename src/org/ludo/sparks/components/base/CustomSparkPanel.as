package org.ludo.sparks.components.base
{
	import flash.utils.describeType;
	
	import org.ludo.sparks.skins.CustomPanelSkin;
	
	import spark.components.Group;
	import spark.components.Panel;
	import spark.primitives.Rect;

	public class CustomSparkPanel extends Panel
	{
		public function CustomSparkPanel()
		{
			super();
			//this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
			this.setStyle("skinClass", Class(CustomPanelSkin));
		}
		[SkinPart(required="true")]
		[Bindable]
		public var titleBar:Group; //need a container to add elements in title bar
		static private const defaultBarHeight:int=30;
		[Bindable]
		public var backgroundFill:uint=0xFFFFFF; //default
		/*
		//--------------------------------------------------------------------------
		//
		//  Custom Function
		//
		//--------------------------------------------------------------------------
		public function set keepShadow(value:Boolean):void
		{
			this.setStyle("dropShadowVisible",value);
			//dropShadow.visible=value;
		}
		public function set keepBorder(value:Boolean):void
		{
			this.setStyle("borderVisible",value);
		}
		*/
		//--------------------------------------------------------------------------
		//
		//  Overridden properties: UIComponent
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  baselinePosition
		//----------------------------------
		override protected function createChildren():void
		{
			super.createChildren()
		}
        private function creationComplete(event:Object):void
        {
        }
		protected override function findSkinParts() : void
		{
			addToParentSkinParts();//This adds parts to parent skin
			super.findSkinParts();
		}
		//This part is taken from http://forums.adobe.com/message/2100953#2100953
		protected function addToParentSkinParts():void
		{
			var classDesc:XML = describeType(this);
			for each (var variable:XML in classDesc.elements("variable"))
			{
				var varName:String = variable.@name;
				for each (var metadata:XML in variable.elements("metadata"))
				{
					var metaName:String = metadata.@name;
					if (metaName == "SkinPart")
					{
						for each (var arg:XML in metadata.elements("arg"))
						{
							var required:Boolean = false;
							if (arg.@key == "required")
							{
								if (arg.@value == "true") required = true;
							}
						}
						skinParts[varName] = required;
					}
				}
			}
		}
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			return getBaselinePositionForPart(titleBar);
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
	        if (instance == titleBar)
	        {
	            titleBar.height = defaultBarHeight;
	            titleBar.visible = true;
	        }
        }
	}
}

