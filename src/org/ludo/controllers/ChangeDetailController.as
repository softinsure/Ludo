package org.ludo.controllers
{
	import org.frest.collections.DataContainer;
	import org.ludo.objects.ChangeDetail;
	import org.ludo.utils.LudoUtils;
	
	public class ChangeDetailController
	{
		//private var changeDeatils:ArrayCollection=[];
		private static var changeDeatils:DataContainer = new DataContainer();
		
		private static var changeDetailController:ChangeDetailController;
		public static function getInstance():ChangeDetailController
		{
			if (changeDetailController == null)
			{
				changeDetailController = new ChangeDetailController();
			}
			return changeDetailController;
		}
		private function addChange(controlid:String,change:ChangeDetail):void
		{
			//actionPanel=bar;
			changeDeatils.put(controlid,change);
		}
		private function getChange(controlid:String):ChangeDetail
		{
			return changeDeatils.get(controlid);
		}
		public function ChangeDetailController()
		{
			if (changeDetailController != null)
			{
				throw new Error("Only one ChangeDetailController instance may be instantiated.");
			}
		}
		public function addDetail(controlid:String,pageid:String,action:String,unitnumber:String,description:String,type:String,valueBeforeChange:String,valueAfterChange:String,datamap:String):void
		{
			var cid:String=generateID(pageid,datamap,controlid,unitnumber);
			//check if change is there
			var nochange:Boolean=false;
			if(changeDeatils.contains(cid))
			{
				var oldchange:ChangeDetail=getChange(cid);
				valueBeforeChange=oldchange.valueBeforeChange;
				if(valueBeforeChange==valueAfterChange)
				{
					//nochange
					nochange=true;
					changeDeatils.remove(cid);
				}
			}
			if(!nochange)
			{
				var change:ChangeDetail=ChangeDetail.addDetail(cid,pageid,action,unitnumber,description,type,valueBeforeChange,valueAfterChange,datamap,LudoUtils.pagesAndPropsController.getPropertyByPageID(pageid,"description"));
				addChange(cid,change);				
			}
		} 
		private function generateID(pageid:String,datamap:String,cid:String,unitnumber:String):String
		{
			if(datamap==null) datamap="";
			if(cid==null) cid="";
			if(unitnumber==null) unitnumber="";
			return pageid+"_"+(datamap==""?cid:datamap)+"_"+unitnumber;
		}
		public function get hasDetail():Boolean
		{
			return changeDeatils.count>0;
		}
		public function get allChanges():XML
		{
			var changes:XML=<ChangeDetails/>
			var changesArray:Array=new Array();
			for each (var change:ChangeDetail in changeDeatils.container)
			{
				changesArray.push(change.toXML());
				//changes.appendChild(change.toXML());
			}
			changesArray.sortOn(["page_description","unitnumber","description","action"]);
			for each (var xml:XML in changesArray)
			{
				changes.appendChild(xml);
			}
			return changes;
		}
		public function set allChanges(changes:XML):void
		{
			if(changes!=null)
			{
				for each (var change:XML in changes.children())
				{
					var change2:ChangeDetail=ChangeDetail.fromXML(change);
					addChange(change2.id,change2);
				}
			}
		}
		public function resetChanges():void
		{
			changeDeatils.empty();
		}
	}
}