package org.ludo.delegates
{
	import mx.rpc.IResponder;
	
	import org.frest.Fr;
	//
	import org.ludo.models.Document;
	
	import org.ludo.utils.LudoUtils;

	public class DocumentDelegate
	{
		private var _responder : IResponder;
		public function DocumentDelegate(responder : IResponder)
		{
			_responder = responder;
		}
/*
		public function createXmlstore(xmlstore:Xmlstore):void {
			ServiceUtils.send("/xmlstores.xml", _responder, "POST",
			xmlstore.toXML(), true);
		}
*/
		public function createDocument(document:Document):void
		{
			Fr.httpSend("/documents.xml",_responder,"POST",document.toUpdateObject(),true);
			//ServiceManager.send("/documents.xml", _responder, "POST",
			//document.toUpdateObject(), true);
		}
		public function viewDocument(documentid:int) : void
		{
			Fr.httpSend("/quotes/" + LudoUtils.modelController.quote.id + "/documents/"+documentid+".xml",_responder);
			//ServiceManager.send(
			//"/quotes/" + model.quote.id + "/documents/"+documentid+".xml" , _responder);
		}
		public function listDocuments() : void
		{
			Fr.httpSend("/quotes/" + LudoUtils.modelController.quote.id + "/documents.xml",_responder);
			//ServiceManager.send(
			//"/quotes/" + model.quote.id + "/documents.xml" , _responder);
		}
		public function updateDocument(document:Document) : void
		{
			Fr.httpSend("/quotes/" + LudoUtils.modelController.quote.id + "/documents.xml",_responder,"PUT",document.toUpdateObject() , false);
			//ServiceManager.send(
			//"/quotes/" + model.quote.id + "/documents.xml", _responder , "PUT" , document.toUpdateObject() , false);
		}
		public function deleteDocument(document:Document):void {
			Fr.httpSend("/documents/" + document.id + ".xml",_responder,"DELETE");
			//ServiceManager.send(
			//"/documents/" + document.id + ".xml",
			//_responder,
			//"DELETE");
		}
	}
}
