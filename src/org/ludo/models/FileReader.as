/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: FileReader.as 
 * Project Name: Ludo 
 * Created Jan 6, 2010
 ******************************************************************************/
package org.ludo.models
{
	[Resource(name="file_reader")]
	[Bindable]
	public class FileReader extends BaseModel
	{
		public var file_path : String;
		[Ignored]
		public function FileReader(label:String="id")
		{
			super(label);
			httpSendMethod="POST";
			doUnmarshall=false;
			showMessage=false;
			//set id to negetive to pass the action in url
			this.id=-1;
		}
	}
}