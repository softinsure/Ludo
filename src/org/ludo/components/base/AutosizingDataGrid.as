/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: AutosizingDataGrid.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.base
{
	import flash.geom.Point;
	import mx.controls.DataGrid;
	import mx.controls.listClasses.ListRowInfo;
	/**
	 * extension of datagrid. collected from net and modified acording to need
	 * @author SoftInsure
	 * 
	 */	
	public class AutosizingDataGrid extends DataGrid
	{
		protected var contentHeight:int = 0;
		public var hideIfNoRow:Boolean=false;
		public var hideParentIfNoRow:Boolean=false;
		public function AutosizingDataGrid()
		{
			super();
			this.defaultRowCount=0;
		}
		protected function checkIfGridToBeHidden():void
		{
			this.visible=hideIfNoRow?dataProvider.length>0:true;
			if(this.parent!=null)
			{
				this.parent.visible=hideParentIfNoRow?dataProvider.length>0:true;
			}
		}
		/**
		 * adjusts the height of the grid
		 * until it either runs out of the rows to draw
		 * or reaches maxHeight (if maxHeight has been set)
		 */
 		protected function getMeasuredHeight(maxHeight:int):Number 
 		{
			/*if the collection has only one row, we ignore the maxHeight by setting it back to its default
			One row cannot scroll, setting a max on that for one very large row (that is more than maxHeight pixels long) will force the 
			row to be cliped */
			var count:int = (collection)?collection.length:0;
			if(count<0) count=0;
			if(collection && count==1) maxHeight = DEFAULT_MAX_HEIGHT;
			if(contentHeight>=maxHeight) return maxHeight;
			
			var hh:int = 0;
			if(!rowInfo||rowInfo.length==0 )
			{
				if(collection)
				{
					contentHeight = Math.min(maxHeight,count * 20);
				}
				else
				{
					contentHeight=0;
				}
				return contentHeight;
			}	
			/* keep on increasing the height until either we run out of rows to draw or maxHeight is reached */
			var len:int = Math.min(rowInfo.length,count);
 			for(var i:int=0;i<len;i++)
			{
 				if(rowInfo[i] && ListRowInfo(rowInfo[i]).uid)
				{
	 				hh += ListRowInfo(rowInfo[i]).height;
	 			}
 			}		

 			/* if hh is less than maxHeight and we still have rows to show, increase the height */
 			if ( hh < maxHeight && rowInfo.length < count )
			{
 				/* if we have already drawn all the rows without hitting the maxHeight, we are good to go */
 				hh = Math.min(maxHeight,hh + (count - rowInfo.length)*20);
 			}
 			contentHeight = Math.min(maxHeight,hh);
			return contentHeight;
		} 	
		protected function measureHeight():void 
		{
			var buffer:int = ((this.horizontalScrollBar!=null)?this.horizontalScrollBar.height:0);
			var maxContentHeight:int = maxHeight - (headerHeight + buffer);
			var listContentHeight:int = this.headerHeight + buffer + getMeasuredHeight(maxContentHeight);
			var hh:int =  listContentHeight + 2;
			if ( hh == this.height ) return;
			listContent.height = listContentHeight;	
			this.height = hh;	
			if ( height >= maxHeight ) {
				this.verticalScrollPolicy = "auto";
			}
			else this.verticalScrollPolicy = "off";
			checkIfGridToBeHidden();
		}
		/**
		 * Override of the corresponding method in mx.controls.AdvancedDataGrid.  After drawing the rows, it calls measureHeight to figure out if 
		 * the height of the grid still needs to be adjusted
		 */
 		protected override function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean=false, rowsNeeded:uint=0.0):Point 
 		{
			var p:Point = super.makeRowsAndColumns(left,top,right,bottom,firstCol,firstRow,byCount,rowsNeeded);
			measureHeight();
			return p;
		}	
	    /**
	    * displayWidth is a private variable in mx.controls.AdvancedDataGridBaseEx.  We need to create it here so that we can 
	    * use it
	    */
		protected var displayWidth:Number;
		/**
		 * We need to override the updateDisplayList so that we can set the displayWidth.  
		 * See the displayWidth variable in mx.controls.AdvancedDataGridBaseEx
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			if (displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left) {
	            displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
	        }
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}	    			
	}
}