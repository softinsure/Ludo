package org.ludo.controllers
{
	import org.ludo.objects.PageProperties;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.XMLMapper;

	public class PagesAndPropertiesController
	{
		private static var pageAndPropertiesController:PagesAndPropertiesController;
		private var pageAndProperties:XML;
		private var viewonly:Boolean=false;
		private var pagesWithProperties:Array=[];
		private var ifQuote:Boolean=false;
		private var otherPage:PageProperties=new PageProperties("internal_other");
		public static function getInstance():PagesAndPropertiesController
		{
			if (pageAndPropertiesController == null)
			{
				pageAndPropertiesController = new PagesAndPropertiesController();
			}
			return pageAndPropertiesController;
		}
		public function PagesAndPropertiesController()
		{
			if (pageAndPropertiesController != null)
			{
				throw new Error("Only one PageAndPropertiesController instance may be instantiated.");
			}
		}
		public function get hasProperties():Boolean
		{
			return pageAndProperties!=null;
		}
		public function get pageProperties():Array
		{
			return pagesWithProperties;
		}
		public function setCutrrentPageAndProperties(ifViewOnly:Boolean=false):void
		{
			ifQuote=LudoUtils.containerController.loadedContainerName=="quote";
			viewonly=ifViewOnly;
			otherPage.readOnly=viewonly;
			pagesWithProperties=[];
			pageAndProperties=XML(LudoUtils.dataStore.getFromXmlContainer("pageandproperties"));
			for each (var xml:XML in pageAndProperties.children())
			{
				//create a new page object
				var pageid:String=String(xml.@id);
				var pageObj:PageProperties=new PageProperties(pageid);
				pageObj.properties=xml;
				setProperties(pageObj);
				pagesWithProperties[xml.@id]=pageObj;
			}
		}
		private function setProperties(page:PageProperties):void
		{
			var readonly:Boolean=false;
			if(viewonly)
			{
				readonly=true;
			}
			else if(ifQuote)
			{
				readonly=viewByQuoteStatus(String(page.properties.@readonlyifquotein));
			}
			page.readOnly=readonly;
			//rate dendant
			var ratedependant:Boolean=false;
			if(ifQuote)
			{
				ratedependant=String(page.properties.@ratedependant)=="Y";
			}
			page.rateDependant=ratedependant;
			page.requiredToBind=String(page.properties.@requiredtobind)=="Y";
			page.description=String(page.properties.@description);
			}
		private function viewByQuoteStatus(viewByQuoteStatus:String=""):Boolean
		{
			if(viewByQuoteStatus=="")
			{
				return false;
			}
			var qstatus:String=LudoUtils.modelController.quote.quote_status;
			for each(var mode:String in viewByQuoteStatus.split(','))
			{
				if(qstatus==mode)
				{
					return true;
					break;
				}
			}
			return false;
		}
		public function getPropertyByPageID(pageid:String,prop:String):String
		{
			var propPage:PageProperties=getPageProperties(pageid);
			if(propPage!=null)
			{
				if(propPage.hasOwnProperty(prop))
				{
					return propPage[prop.toLowerCase()];
				}
				else
				{
					return "";
				}
			}
			return "";
		}
		public function getPagesByAttribute(filterBy:String,filterValue:String):XMLList
		{
			//return pageAndProperties.page.(attribute(attribute)==value).@id;
			return pageAndProperties.page.(attribute(filterBy)==filterValue);
		}
		public function getPageProperties(pageid:String):PageProperties
		{
			return pagesWithProperties[pageid]==null?otherPage:pagesWithProperties[pageid];
		}
	}
}