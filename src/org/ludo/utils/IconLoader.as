package org.ludo.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLLoaderDataFormat;
	
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	
	import org.frest.Fr;
	import org.ludo.connectors.ImageConnector;
	
	public class IconLoader extends BitmapAsset
	{
		public function IconLoader():void
		{
		}
		public static function getClass( target:UIComponent, source:String, width:Number = NaN, height:Number = NaN ):Class {
			Fr.httpLoad(source,completeLoad,[target,width,height],"GET",URLLoaderDataFormat.BINARY);
			return IconLoader;
		}
		public static function getIcon(target:UIComponent,iconPath:String, width:Number = NaN, height:Number = NaN ):Class {
			var iconClass:Class=ImageConnector.getImageByName(iconPath);
			var icon:Bitmap=Bitmap(new iconClass() as BitmapAsset);
			
			
			//var bitmapData:BitmapData =icon.bitmapData;
			icon.bitmapData.draw(target, new Matrix());
			//icon.invalidateSize();
			//var targetData:UIComponent=target.data as UIComponent;
			//var bitmapData:BitmapData = new BitmapData(targetData.width, targetData.height, true, 0x00FFFFFF);
			//bitmapData.draw(targetData, new Matrix(targetData.width/124, 0, 0, targetData.height/124, 0, 0));
			target.invalidateSize();
			target.addChild(icon);
			//return icon;
			return IconLoader;
		}
		private static function displayIcon(event:Event,argumentArray:Array):void
		{
			var icon:Loader=event.target.loader;
			var bitmapData:BitmapData;
			bitmapData= new BitmapData(icon.content.width,icon.content.height, true, 0x00FFFFFF);;
			//bitmapData= new BitmapData(icon.content.width, icon.content.height, true, 0x00FFFFFF);;
			bitmapData.draw(icon, new Matrix(bitmapData.width/icon.content.width, 0, 0, bitmapData.height/icon.content.height, 0, 0));
			var parent:UIComponent=argumentArray[0] as UIComponent;
			if(!parent.contains(icon))
			{
				parent.addChild(icon);
			}
			parent.invalidateSize();
		}
		
		public static function completeLoad(event:Event,argumentArray:Array):void
		{
			if(event && event.target && event.target.data)
			{
				var icon:Loader = new Loader();
				icon.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					displayIcon.call(this,event,argumentArray)
				});
				//icon.contentLoaderInfo.addEventListener(Event.COMPLETE,displayIcon);
				icon.loadBytes(event.target.data);
				//var parent:UIComponent=argumentArray[0] as UIComponent;
				//var bitmapData:BitmapData = new BitmapData(parent.width, parent.height, true, 0x00FFFFFF);
				//bitmapData.draw(parent, new Matrix(bitmapData.width/arguments[1], 0, 0, bitmapData.height/arguments[2], 0, 0));
				//parent.invalidateSize();
				//parent.addChild(icon);
			}
		}
	}
}