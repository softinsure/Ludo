package org.ludo.objects
{
	import org.ludo.utils.LudoUtils;

	public class ChangeDetail extends Object
	{
		public var id:String="";
		private var _pageid:String="";
		private var _page_description:String="";
		private var _action:String="";
		private var _description:String="";
		private var _type:String="";
		private var _unitnumber:String="";
		private var _valueBeforeChange:String="";
		private var _valueAfterChange:String="";
		private var _datamap:String="";
		
		public function ChangeDetail()
		{
			super();
		}

		public function get pageid():String
		{
			return _pageid;
		}
		public function get action():String
		{
			return _action;
		}
		public function get page_description():String
		{
			return _page_description;
		}
		public function get description():String
		{
			return _description;
		}
		public function get type():String
		{
			return _type;
		}
		public function get unitnumber():String
		{
			return _unitnumber;
		}
		public function get valueBeforeChange():String
		{
			return _valueBeforeChange;
		}
		public function get valueAfterChange():String
		{
			return _valueAfterChange;
		}
		public function get datamap():String
		{
			return _datamap;
		}
		public static function addDetail(controlid:String,pageid:String,action:String,unitnumber:String,description:String,type:String,valueBeforeChange:String,valueAfterChange:String,datamap:String, pageDesc:String):ChangeDetail
		{
			var aChangeDetail:ChangeDetail=new ChangeDetail();
			aChangeDetail.id=controlid;
			aChangeDetail._pageid=pageid;
			if(pageDesc=="")
			{
				pageDesc=LudoUtils.pagesAndPropsController.getPropertyByPageID(pageid,"description");
			}
			aChangeDetail._page_description=pageDesc;
			aChangeDetail._description=description;
			aChangeDetail._type=type;
			aChangeDetail._action=action;
			aChangeDetail._unitnumber=unitnumber;
			aChangeDetail._valueBeforeChange=valueBeforeChange;
			aChangeDetail._valueAfterChange=valueAfterChange;
			aChangeDetail._datamap=datamap;
			return aChangeDetail;
		}
		public function toXML() : XML
		{
			var retval:XML =
				<change_detail>
				<id>{id}</id>
				<pageid>{_pageid}</pageid>
				<page_description>{_page_description}</page_description>
				<action>{_action}</action>
				<unitnumber>{_unitnumber}</unitnumber>
				<description>{_description}</description>
				<type>{_type}</type>
				<value_before_change>{_valueBeforeChange}</value_before_change>
				<value_after_change>{_valueAfterChange}</value_after_change>
				<datamap>{_datamap}</datamap>
			</change_detail>;
			return retval;
		}
		public static function fromXML(change_detail:XML):ChangeDetail
		{
			return ChangeDetail.addDetail(
				change_detail.id,
				change_detail.pageid,
				change_detail.action,
				change_detail.unitnumber,
				change_detail.description,
				change_detail.type,
				change_detail.value_before_change,
				change_detail.value_after_change,
				change_detail.datamap,
				change_detail.page_description
			);
		}
	}
}