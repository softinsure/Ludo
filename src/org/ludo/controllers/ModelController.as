package org.ludo.controllers {
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ListCollectionView;
    import mx.containers.*;
    
    import org.frest.controllers.FrModelsController;
    import org.ludo.models.*;
    import org.ludo.utils.XMLMapper;

    [Bindable]
    public class ModelController extends FrModelsController{

		///////////////////// User \\\\\\\\\\\\\\\\\\\\
       //public var user:User;
        //public var userToUpdate:User;
        //public var users:ListCollectionView;
        
        ///////////////////// agency \\\\\\\\\\\\\\\\\\\\
        //public var agency:Agency;
        //public var agencyToUpdate:Agency;
        //public var users:ListCollectionView;

        ///////////////////// agent \\\\\\\\\\\\\\\\\\\\
        //public var agent:Agent;
        //public var agentToUpdate:Agent;

		///////////////////// policy header \\\\\\\\\\\\\\\\\\\\
		public function get policyHeader():PolicyHeader
		{
			return this.collections.getFromCollection("policyHeader") as PolicyHeader;
		}
		public function set policyHeader(value:PolicyHeader):void
		{
			this.collections.addToCollection("policyHeader",value);
		}
		//public var agentToUpdate:Agent;

        ///////////////////// Quote \\\\\\\\\\\\\\\\\\\\
       	public function get currentSession():Session
        {
			return this.collections.getFromCollection("currentSession") as Session;
        }
       	public function set currentSession(value:Session):void
        {
			if(value==null)
			{
				this.collections.remove("currentSession");
			}
			else
			{
				this.collections.addToCollection("currentSession",value);
			}
		}
        ///////////////////// Quote \\\\\\\\\\\\\\\\\\\\
       	public function get quote():Quote
        {
			return this.collections.getFromCollection("quote") as Quote;
        }
       	public function set quote(value:Quote):void
        {
			this.collections.addToCollection("quote",value);
        }
        //public var quote:Quote;
        //public var quotes:ListCollectionView;
        
		//model used to read config files
		public var configFileReader:FileReader = new FileReader("configreader");
       ///////////////////// Xmlstore \\\\\\\\\\\\\\\\\\\\
        //public var xmlstore:Xmlstore;
        /*
       	public function get xmlstore():Xmlstore
        {
			return this.collections.getModel("xmlstore") as Xmlstore;
        }
       	public function set xmlstore(value:Xmlstore):void
        {
			this.collections.addModel("xmlstore",value);
        }
        */
       	public function get errorlog():ErrorLog
        {
			return this.collections.getFromCollection("errorlog") as ErrorLog;
        }
       	public function set errorlog(value:ErrorLog):void
        {
			this.collections.addToCollection("errorlog",value);
        }
        
        ///////////////////// ErrorLog \\\\\\\\\\\\\\\\\\\\
        //public var errorlog:ErrorLog;
        //public var errorlogs:ListCollectionView;
        
        ///////////////////// Document \\\\\\\\\\\\\\\\\\\\
        public var documents:ListCollectionView;            
        public var document:Document;
		
       	public var xmlMapper:XMLMapper;
       	
        private static var modelLocator:ModelController;

        public static function getInstance():ModelController
		{
            if (modelLocator == null)
            {
            	References.initiateReferences();
			    modelLocator = new ModelController(generateLock());
			}
            return ModelController(modelLocator);
        }
        //The constructor should be private, but this is not
        //possible in ActionScript 3.0. So, throwing an Error if
        //a second LudoModelLocator is created is the best we
        //can do to implement the Singleton pattern.
        public function ModelController(lock:Class)
        {
        	super(lock);
/*
            if (modelLocator != null) {
                throw new Error("Only one ModelLocator instance may be instantiated.");
            }
*/
        }
		public function getModelToUpdateFromClassPath(classpath:String,id:int=0):BaseModel
		{
			var definition:Class=getDefinitionByName(classpath) as Class;
			var model:BaseModel = new definition();
			model.id=id;
			this.addModelToUpdate(model);
			return model;
		}

        ///////////////////// FUNCTIONS \\\\\\\\\\\\\\\\\\\\
		/*
        public function hasModelToUpdate(modelname:String):Boolean
        {
        	return this.collections.contains(modelname+"ToUpdate");
        	//return this[modelname+"ToUpdate"]!=null;
        }
        public function getModelToUpdate(modelname:String):BaseModel
        {
        	return this.collections.getModel(modelname+"ToUpdate") as BaseModel;
        	//return this[modelname+"ToUpdate"] as BaseModel;
        }
        //public function addModelToUpdate(modelname:String,model:BaseModel):void
        public function addModelToUpdate(model:BaseModel):void
        {
        	this.collections.addToCollection(getModelName(model).toLowerCase()+"ToUpdate",model);
         }
		public function getModelToUpdateFromClassPath(classpath:String,id:int=0):BaseModel
		{
				var definition:Class=getDefinitionByName(classpath) as Class;
				var model:BaseModel = new definition();
				model.id=id;
				this.addModelToUpdate(model);
				return model;
		}
        public function hasModel(modelname:String):Boolean
        {
        	return this.collections.contains(modelname);
        	//return this[modelname]!=null;
        }
        public function getModel(modelname:String):BaseModel
        {
        	return this.collections.contains(modelname) as BaseModel;
        	//return this[modelname] as BaseModel;
        }
		*/
        //public function addModel(modelname:String,model:BaseModel):void
        /*
        public function addModel(model:BaseModel):void
        {
        	this.collections.addToCollection(getModelName(model).toLowerCase(),model);

        }
        */
        public function setxmlMapper(root:String):void
        {
        	xmlMapper = new XMLMapper(this.quote.xmlstore.xmlstring,root);
        }
		public function getNewPolicyHeaderModel(label:String):PolicyHeader
		{
			var aPHeader:PolicyHeader=new PolicyHeader(label);
			this.policyHeader=aPHeader;
			return aPHeader;
		}
        public function getNewQuoteModel(label:String,transaction:String="",lob:String=""):Quote
        {
        	var aQuote:Quote=new Quote(label);
        	aQuote.transaction(transaction,lob);
        	this.quote=aQuote;
        	
        	/*
        	this.quote=null;//destroy existing one
        	this.quote=new Quote(label);
        	this.quote.transaction(transaction,lob);
        	*/
        	//this.collections.addToCollection("quote",this.quote);
        	return this.quote;
        }
        /*
        public function getNewErrorModel(label:String,errordesc:String,errortype:String="",errorsource : String = "",errorname : String = ""):ErrorLog
        {
        	this.errorlog=null;
        	this.errorlog=new ErrorLog(label);
        	this.errorlog.error_desc=errordesc;
        	this.errorlog.error_type=errortype;
        	this.errorlog.error_source=errorsource;
        	this.errorlog.error_name=errorname;
        	if(quote!=null)
        	{
        		this.errorlog.quote_id=this.quote.id;
        	}
        	return this.errorlog;
        }
        */
        public function getNewErrorModel(label:String,errordesc:String,errortype:String="",errorsource : String = "",errorname : String = ""):ErrorLog
        {
        	var aErrorlog:ErrorLog=new ErrorLog(label);
        	aErrorlog.error_desc=errordesc;
        	aErrorlog.error_type=errortype;
        	aErrorlog.error_source=errorsource;
        	aErrorlog.error_name=errorname;
        	if(this.quote!=null)
        	{
        		aErrorlog.quote_id=this.quote.id;
        	}
        	this.errorlog=aErrorlog;
        	return this.errorlog;
        }
        /*
        public function getNewXmlstoreModel(label:String,belongsTo:FrModel):Xmlstore
        {
        	var aXmlstore:Xmlstore=new Xmlstore(label);
        	aXmlstore.belongsTo=belongsTo;
        	this.xmlstore=aXmlstore;
        	return this.xmlstore;
        }
        */
        public function setDocuments(list:XMLList):void 
        {
            var documentsArray:Array = [];
            for each (var item:XML in list)
            {
                documentsArray.push(Document.fromBase64XML(item));
            }
            documents = new ArrayCollection(documentsArray);
       	}
        public function getModelName(model:Object):String
        {
        	var vArray:Array=getQualifiedClassName(model).split("::");
        	return vArray[vArray.length-1];
        }
        /*
		public function toXML(object:Object):XML
		{
			var modelXML:XML=describeType(object);
			var nameArray:Array=modelXML.@name.split("::");
			var name:String=nameArray[nameArray.length-1];
			var accessors:XMLList=modelXML..accessor;
			var toxmlstring:String="";
			var dbdtformat:String=LudoUtils.dbDateFormat();
			for(var i:int; i < accessors.length(); i++)
			{
				var val:String=object[accessors[i].@name];
				//chcek if date
				if(XDateUtil.isDate(val))
				{
					//change to DB format
					val=XFormatter.formatDateString(val,dbdtformat);
				}
				toxmlstring=toxmlstring+"<"+accessors[i].@name+">"+val+"</"+accessors[i].@name+">";
			}
			name=name.toLowerCase();
			return XML("<"+name+">"+toxmlstring+"</"+name+">");
		}
 		public function toUpdateObject(model:Object):Object
		{
			var obj : Object = new Object();
			var modelName:String=getModelName(model).toLowerCase();
			var modelXML:XML=describeType(model);
			var accessors:XMLList=modelXML..accessor;
			var dbdtformat:String=LudoUtils.dbDateFormat();
			for(var i:int; i < accessors.length(); i++)
			{
				var val:String=model[accessors[i].@name];
				//chcek if date
				if(XDateUtil.isDate(val))
				{
					//change to DB format
					val=XFormatter.formatDateString(val,dbdtformat);
				}
				
				obj[modelName+"["+accessors[i].@name+"]"] = val;
			}
			return obj;
		}
		public function fromXMLToModel(model:Object,modelXML:XML):Object
		{
			if(model!=null)
			{
				var displaydtformat:String=LudoUtils.displayDateFormat();
				for each (var element:XML in modelXML..elements())
				{
					if(model.hasOwnProperty(element.name()))
					{
						var val:String=element.text();
						//check for datetime
						if(element.@type=="datetime" && val!="")
						{
							val=XFormatter.formatDateString(val,displaydtformat);
						}
						model[element.name()]=val;
					}
				}
			}
			return model;
		}
		*/
    }
}