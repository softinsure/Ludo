package org.ludo.utils
{
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	
	import org.ludo.models.List;
	
	public dynamic class LookupSource
	{
		private static var lookupSource:LookupSource;

        public static function getInstance():LookupSource{
            if (lookupSource == null) {
                lookupSource = new LookupSource()
            }
            return lookupSource;
        }
        public function getSource(sourcename:String,type:String="default"):*
        {
        	var source:Object;
 			switch(type.toLowerCase())//type
			{
				case 'database':
					source=LudoUtils.dataStore.getFromXmlContainer(sourcename.toLowerCase());
					break;
				case 'webservice':
					break;
				default:
					switch(sourcename.toLowerCase())
					{
						case 'workitem':
							source=LudoUtils.modelController.quote.xmlstore.xmlstring;//the stored acord for a quote
							break;
						default:
							source=LudoUtils.dataStore.getFromXmlContainer(sourcename);
							break
					}
	
					break
			}
			if(source==null)
			{
				throw new Error("No source to load! Source can be used after loading.");
			}
			else
			{
				return source;
			}   	
        }
		private function getNodeValue(node:XML):String
		{
			var value:String="";
			if(node!=null)
			{
				switch(node.nodeKind())
				{
					case 'element':
					case 'text':
						value=node.toString();
						break;
					default:
						value=node.toString();
						break
				}
			}
			return value;
		}
		public function getFieldSets(id:String):XMLList
		{
			return LudoUtils.dataStore.getFromXmlContainer(LudoUtils.transController.fieldsetid).fieldset.(@id == id);
		}
		public function getGridSets(id:String):XMLList
		{
			return LudoUtils.dataStore.getFromXmlContainer("gridsets").gridset.(@id == id);
		}
		public function getCoverageLookup(code:String):XML
		{
			return LudoUtils.dataStore.getFromXmlContainer("coveragelookup").Coverage.(@code == code)[0];
		}
		public function setOptionArray(lookupsource:String,displayObject:IVisualElement):void
		{
			//xml::workitem::driver::listtemplate
			var source:Array = lookupsource.split("::");
			if(source.length>=3)
			{
				switch(source[0].toLowerCase())//source type=xml,database,webservice
				{
					case 'database':
						getOptionArrayFromDB(source[1].toLowerCase(),source[2],displayObject);
						break;
					case 'webservice':
						break;
					default://xml
						var sourceXml:XML;
						switch(source[1].toLowerCase())
						{
							case 'workitem':
								//check for template
								var template:String="defaultlisttemplate";
								if(source.length>3)
								{
									//4th one is template
									template=source[3];
								}
								LudoUtils.setDataProvider(displayObject,getOptionArrayFromWorkItem(template,source[2]));
								break;
							default:
								LudoUtils.setDataProvider(displayObject,getOptionArrayFromOptionList(source[1].toLowerCase(),source[2]));
								//displayObject.dataprovider=getOptionArrayFromOptionList(source[1].toLowerCase(),source[2]);
								break
						}
					break
				}				
			}
		}
		public function optionArray(lookupsource:String):ArrayCollection
		{
			//xml::workitem::driver::listtemplate
			var source:Array = lookupsource.split("::");
			var optionCol:ArrayCollection;
			if(source.length>=3)
			{
				switch(source[0].toLowerCase())//source type=xml,database,webservice
				{
					case 'database':
					case 'webservice':
						break;
					default://xml
						var sourceXml:XML;
						switch(source[1].toLowerCase())
						{
							case 'workitem':
								//check for template
								var template:String="defaultlisttemplate";
								if(source.length>3)
								{
									//4th one is template
									template=source[3];
								}
								optionCol=getOptionArrayFromWorkItem(template,source[2]);
								break;
							default:
								optionCol=getOptionArrayFromOptionList(source[1].toLowerCase(),source[2]);
								break
						}
					break
				}				
			}
			return optionCol;
		}
		private function generateQuery(list:XML):String
		{
			var where:String=String(list.query.where);
			where=where != "" ? " where " + where : "";

			var order:String=String(list.query.orderby);
			order=order != "" ? " order by " + order : "";

			return 'select ' + String(list.query.select) + ' from ' + String(list.query.from) + where + order;
		}
		public function getOptionArrayFromDB(source:String,optionid:String,displayobject:IVisualElement):void
		{
			var listSource:XML=getSource(source).options.(@id == optionid)[0] as XML;
			var list:List=new List();
			list.query=generateQuery(listSource);
			list.control=displayobject;
			list.list();
		}
		public function getOptionArrayFromOptionList(source:String,optionid:String):ArrayCollection
		{
			var optCol:ArrayCollection=new ArrayCollection();
			var list:XML=getSource(source) as XML;
			for each (var xml:XML in list.options.(@id == optionid).children())
			{
				var obj:Object=new Object();
				obj.label=xml.text().toXMLString();
				obj.data=String(xml.@data);
				optCol.addItem(obj);	
			}
			return optCol;
		}
		private function getOptionArrayFromWorkItem(template:String,id:String):ArrayCollection
		{
			var optCol:ArrayCollection=new ArrayCollection(); 
			//get the template
			var xml:XML=getSource(template).template.(@id == id)[0];
			if(xml!=null)
			{
				//read the groupmap
				var groupmap:String=xml.groupmap.toString();
				//read valuefield
				var valuefield:String=xml.valuefield.toString();
				var valuefieldtype:String="attribute";//default
				var fieldsets:XMLList=xml.fieldSet.children();
				var filter:Boolean=false;
				if(groupmap!="" && valuefield!="" && fieldsets !=null)
				{
					if(xml.valuefield.hasOwnProperty("@type"))
					{
						valuefieldtype=xml.valuefield.@type.toString();
					}
					//if(xml.blankoption.hasSimpleContent())
					if(xml.hasOwnProperty("blankoption"))
					{
						var blank:Object=new Object();
						blank.label=xml.blankoption.toString();
						if(xml.blankoption.hasOwnProperty("@data"))
						{
							blank.data=xml.blankoption.@data.toString();
						}
						else
						{
							blank.data="";
						}
						optCol.addItem(blank);
					}
					if(xml.hasOwnProperty("filter"))
					{
						groupmap=groupmap+"["+xml.filter.toString()+"]";
						//filter=true;
					}					
					//get the nodelist
					var nodelist:XMLList=LudoUtils.modelController.xmlMapper.getNodeByXpath(groupmap);
					for each(var node:XML in nodelist)
					{
						var obj:Object=new Object();
						obj.label=formatByFieldSets(node,fieldsets);
						if(valuefieldtype=="element")
						{
							obj.data=node[valuefield].toString();
						}
						else
						{
							obj.data=node.@[valuefield].toString();
						}
						optCol.addItem(obj);				
					}
				}
				else
				{
					throw new Error("Template groupmap or valuefield or fieldsets not specified.");
				}
				
			}
			return optCol;
		}
		private function formatByFieldSets(data:XML,fieldsets:XMLList):String
		{
			var label:String="";
			for each (var field:XML in fieldsets)
			{
				switch(String(field.@type).toLowerCase())
				{
					case 'string':
						label=label+field.toString();
						break;
					case 'space':
						label=label+" ";
						break;
					case 'field':
						label=label+XMLMapper.getNodeByXpathAndRootNode(data,field.toString()).toString();
						break;
					default:
						label=label+field.toString();
						break
				}				
			}
			return label;
		}
		public function getValueFromLookupSource(lookupsource:String,lookupcode:String):String
		{
			//optionlist::combolist::incidentType
			var source:Array = lookupsource.split("::");
			var retVal:String="";
			if(source.length>=3)
			{
				switch(source[0].toLowerCase())//type
				{
					case 'xml':
					//always from xml type
						retVal=getSource(source[1]).options.(@id == source[2]).option.(@data ==lookupcode).toString();
						break;
					default:
						retVal=getSource(source[1]).options.(@id == source[2]).option.(@data ==lookupcode).toString();
						break
				}				
			}
			return retVal;
		}
        //The constructor should be private, but this is not
        //possible in ActionScript 3.0. So, throwing an Error if
        //a second AppLudoUtils.dataStore is created is the best we
        //can do to implement the Singleton pattern.
        public function LookupSource() {
            if (lookupSource != null) {
                throw new Error("Only one LookupSource instance may be instantiated.");
            }
        }
     }
}