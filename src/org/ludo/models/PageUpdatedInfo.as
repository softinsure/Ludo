package org.ludo.models
{
	import org.ludo.utils.LudoUtils;

	[Resource(name="page_updated_infos")]
	[Bindable]
	public class PageUpdatedInfo extends BaseModel
	{
		public var pageid : String;
		public var required_fields_entered:Boolean=false;
		public var quote_id : int;
		public var unit_seq : int;
		public function PageUpdatedInfo(label:String="id")
		{
			super(label);
			showMessage=false;
			//afterCreate=attachToQuote;
		}
		/*
		private function attachToQuote(event:Object):void
		{
			//LudoUtils.modelController.quote.pageUpdatedInfo.addModel(this.internalKey,this);
		}
		*/
	}
}