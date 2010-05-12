package org.ludo.controllers
{
	import org.ludo.utils.LudoUtils;

	public class TemplateController
	{
		private static var templateController:TemplateController;
		public static function getInstance():TemplateController
		{
			if (templateController == null)
			{
				templateController = new TemplateController();
			}
			return templateController;
		}
		public function TemplateController()
		{
			if (templateController != null)
			{
				throw new Error("Only one TemplateController instance may be instantiated.");
			}
		}
		public function getTemplate(id:String,xmlname:String="basetemplate"):XML
		{
			return XML(LudoUtils.dataStore.getFromXmlContainer(xmlname).template.(@id == id)).copy();
		}
	}
}