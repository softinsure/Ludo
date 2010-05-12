package org.ludo.models
{
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	[RemoteClass(alias="models.Document")]    
    [Bindable]
    public class Document
	{

        public var id:int;
        public var quote_id:int;
        public var filename:String;
        public var content_type:String;
        public var description:String;
        public var document_data:ByteArray;

        public function Document(source:Object=null)
        {
            if ( source != null )
            {
                for ( var element:String in source )
                {
                    try {
                        this[element] = source[element];
                    }
                    catch ( error:Error )
                    {
                        throw new Error ( "DocumentVO" + error );
                    }
                }
            }
        }
		public function toUpdateObject() : XML
		{
			var base64:Base64Encoder = new Base64Encoder();
			base64.encodeBytes(document_data);
			var retval:XML =
			<documents>
			<id>{id}</id>
			<document_data>{document_data}</document_data>
			<quote_id>{quote_id}</quote_id>
			<filename>{filename}</filename>
			</documents>;
			return retval;
		}
		/*
		public function toUpdateObject() : Object
		{
			var base64:Base64Encoder = new Base64Encoder();
			base64.encodeBytes(document_data);
			var obj : Object = new Object();
			obj["document[id]"] =id;
			obj["document[quote_id]"] =23;
			obj["document[filename]"] = this.filename;
			obj["document[document]"] = this.document_data;
			return obj;
		}
		*/
		/*
		public function toUpdateObject():Object
		{
			var base64:Base64Encoder = new Base64Encoder();
			base64.encodeBytes(document_data);
			var documents:Object=new Object();
			documents.id=this.id;
			documents.quote_id=23;
			documents.filename=this.filename;
			documents.document=this.document_data;
			//document.document=base64.toString();
			return documents;
		}
		/*
		public function toBase64UpdateObject() : Object
		{
			//encode before sending
			var base64:Base64Encoder = new Base64Encoder();
			var obj : Object = new Object();
			obj["document[id]"] =id;
			obj["document[quote_id]"] =quote_id;
			obj["document[document]"] = String(base64.encode(document_data));
			return obj;
		}
		*/
		public static function fromBase64XML(document:XML):Document
		{
			var base64:Base64Decoder = new Base64Decoder();
			base64.decode(document.document_data);
			//var decoded:ByteArray = base64.toByteArray();
			var obj:Object=new Object();
			obj.quote_id=document.quote_id;
			obj.filename=document.filename;
			obj.description=document.description;
			obj.content_type=document.content_type;
			obj.id=document.id;
			obj.document_data=base64.toByteArray();				
			return new Document(obj);
		}
	}
}