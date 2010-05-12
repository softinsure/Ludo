/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: GridColumnDataGrid.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	
	import mx.core.ClassFactory;
	
	import org.ludo.components.mxml.NestedGrid;
	
	public class GridColumnDataGrid extends CustomGridColumn
	{
		public function GridColumnDataGrid(columnInfo:XML,pageid:String="")
		{
			super(columnInfo,pageid);
			var factory:ClassFactory=new ClassFactory(NestedGrid);
			factory.properties={setGridSet:String(columnInfo.@fieldset),setDataField:dataField};
			this.itemRenderer = factory;
		}
	}	 
}
