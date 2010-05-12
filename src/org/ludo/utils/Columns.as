package org.ludo.utils
{
	import mx.controls.dataGridClasses.DataGridColumn;
	
	import org.ludo.components.custom.GridColumnButton;
	import org.ludo.components.custom.GridColumnButtonBar;
	import org.ludo.components.custom.GridColumnCheckBox;
	import org.ludo.components.custom.GridColumnDataField;
	import org.ludo.components.custom.GridColumnDataGrid;
	import org.ludo.components.custom.GridColumnFieldSet;

	public class Columns
	{
		/*
		public function columns()
		{
		}
		*/
		public static function createDataGridColumn(_gridColumn:XML):DataGridColumn
		{
            
            var _datagridcol:DataGridColumn = new DataGridColumn(_gridColumn.@datafield);
            if(String(_gridColumn.@header) != "")
			{
            	_datagridcol.headerText=_gridColumn.@header;
            }
            else
            {
            	//default datafield
            	_datagridcol.headerText=_gridColumn.@datafield;
           	}
            if(String(_gridColumn.@width) != "")
			{
            	_datagridcol.width=_gridColumn.@width;
            }
            return _datagridcol
        }
		public static function addColumnsColumnArray(columns:Array,columncollection:XMLList):Array
		{
			var _columns:Array = columns;
			for(var colcount:int = 0; colcount < columncollection.length(); colcount++)
			{
				_columns.push(createDataGridColumn(columncollection[colcount]));
	       	}
	       	return _columns;
	    }
		public static function createColumnArray(columncollection:XMLList):Array
		{
			var _columns:Array = [];
			for(var colcount:int = 0; colcount < columncollection.length(); colcount++)
			{
				_columns.push(createDataGridColumn(columncollection[colcount]));
	       	}
	       	return _columns;
		}
        public static function CreateDataGridColumn(_gridColumn:XML):DataGridColumn
        {   
            var _datagridcol:DataGridColumn = new DataGridColumn(_gridColumn.@datafield);
            _datagridcol.dataField=_gridColumn.@datafield;
            if(String(_gridColumn.@header) != "")
			{
            	_datagridcol.headerText=_gridColumn.@header;
            }
            else
            {
            	//default datafield
            	_datagridcol.headerText=_gridColumn.@datafield;
           	}
            if(String(_gridColumn.@width) != "")
			{
            	_datagridcol.width=_gridColumn.@width;
            }
            return _datagridcol
        }
        /*
        public static function CreateDataGridColumnNested(_gridColumn:XML):DataGridColumn {
            
            var _datagridcol:DataGridColumnNested = new DataGridColumnNested(_gridColumn.@datafield,String(_gridColumn.@lookupsource));
            _datagridcol.dataField=_gridColumn.@datafield;
            if(String(_gridColumn.@header) != "")
			{
            	_datagridcol.headerText=_gridColumn.@header;
            }
            else
            {
            	//default datafield
            	_datagridcol.headerText=_gridColumn.@datafield;
           	}
            if(String(_gridColumn.@width) != "")
			{
            	_datagridcol.width=_gridColumn.@width;
            }
             return _datagridcol
        }
        */
        public  static function createGridColumnArray(columncollection:XMLList,pageid:String=""):Array
		{
			var _columns:Array = [];
			for(var colcount:int = 0; colcount < columncollection.length(); colcount++)
			{
				switch(String(columncollection[colcount].@type).toLowerCase())
				{
					case 'fieldset':
						_columns.push(new GridColumnFieldSet(columncollection[colcount],pageid));
						//_columns.push(CreateDataGridColumnFieldSet(columncollection[colcount]));
						break;
					case 'datagrid':
						_columns.push(new GridColumnDataGrid(columncollection[colcount],pageid));
						//_columns.push(CreateDataGridColumnFieldSet(columncollection[colcount]));
						break;
					case 'button':
						_columns.push(new GridColumnButton(columncollection[colcount],pageid));
						break;
					case 'buttonbar':
						_columns.push(new GridColumnButtonBar(columncollection[colcount],pageid));
						//_columns.push(CreateDataGridColumnButtonBar(columncollection[colcount]));
						break;
					case 'checkbox':
						_columns.push(new GridColumnCheckBox(columncollection[colcount],pageid));
						//_columns.push(CreateDataGridColumnButtonBar(columncollection[colcount]));
						break;
					default:
						_columns.push(new GridColumnDataField(columncollection[colcount],pageid));
						break
				}
	       	}
	       	return _columns;
		}
		/*
       public  static function CreateNestedColumnArray(columncollection:XMLList):Array
		{
			var _columns:Array = [];
			for(var colcount:int = 0; colcount < columncollection.length(); colcount++)
			{
				switch(String(columncollection[colcount].@type).toLowerCase())
				{
					case 'fieldset':
						_columns.push(new DataGridColumnFieldSet(columncollection[colcount]));
						//_columns.push(CreateDataGridColumnFieldSet(columncollection[colcount]));
						break;
					case 'datagrid':
						_columns.push(new DataGridColumnDataGrid(columncollection[colcount]));
						//_columns.push(CreateDataGridColumnFieldSet(columncollection[colcount]));
						break;
					case 'button':
						_columns.push(new DataGridColumnButton(columncollection[colcount]));
						//_columns.push(CreateDataGridColumnButton(columncollection[colcount]));
						break;
					case 'buttonbar':
						_columns.push(new DataGridColumnButtonBar(columncollection[colcount]));
						//_columns.push(CreateDataGridColumnButtonBar(columncollection[colcount]));
						break;
					default:
						_columns.push(new DataGridColumnDataField(columncollection[colcount]));
						break
				}
	       	}
	       	return _columns;
		}
		*/
		/*
        public static function CreateColumnArray(columncollection:XMLList):Array
		{
			var _columns:Array = [];
			for(var colcount:int = 0; colcount < columncollection.length(); colcount++)
			{
				switch(String(columncollection[colcount].@type).toLowerCase())
				{
					case 'button':
						_columns.push(new DataGridColumnButton(columncollection[colcount]));
						//_columns.push(CreateDataGridColumnButton(columncollection[colcount]));
						break;
					default:
						_columns.push(CreateDataGridColumn(columncollection[colcount]));
						break
				}
				//_columns.push(CreateDataGridColumn(columncollection[colcount]));
	       	}
	       	return _columns;
		}
		*/
	}
}