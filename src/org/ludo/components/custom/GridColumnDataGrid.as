/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
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
			factory2=new ClassFactory(NestedGrid);
			factory2.properties={setGridSet:String(columnInfo.@fieldset),setDataField:dataField};
			//this.itemRenderer = factory;
		}
	}	 
}
