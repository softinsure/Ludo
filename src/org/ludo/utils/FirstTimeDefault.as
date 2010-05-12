package org.ludo.utils
{
	
	
	
	public class FirstTimeDefault
	{
		private static var firstTimeDefault:FirstTimeDefault;
		private static var firstTimeDefaultSets:XML;

        public static function getInstance():FirstTimeDefault{
            if (firstTimeDefault == null) {
                firstTimeDefault = new FirstTimeDefault();
            }
            return firstTimeDefault;
        }
        public function resetSource():void
        {
        	firstTimeDefaultSets=LudoUtils.dataStore.getFromXmlContainer("firsttimedefaultsets");
        }
        private function getFieldSets(sourcename:String):XMLList
        {
        	if(firstTimeDefaultSets == null)
        	{
        		resetSource();
        	}
        	if(firstTimeDefaultSets != null)
        	{
	        	var source:Array = sourcename.split("::");
	        	if(source.length>1)
	        	{
		        	switch(source[0].toLowerCase())//type
					{
						case 'xml':
							return firstTimeDefaultSets.firsttimedefault.(@id == source[1]);
							break;
						default:
							throw new Error("No such source available.");
							break
					}
	        	}
	        	else
	        	{
        			throw new Error("Invalid source path.");
	        	}
        	}
        	else
        	{
        		throw new Error("No source to parse! Please create firsttimedefaultvalue sets.");
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
		/*
		public function setDefaultToUnitOld(firstTimeDefaultSet:String):void
		{
			var counter:int=0;
			for each (var node:XML in getFieldSets(firstTimeDefaultSet))
			{
				var type:String=String(node.@type);
				var keepRoot:String=String(node.@unitroot);
				var unitRoot:String=String(node.@unitroot);
				var unitSeq:int=0;
				var unitNode:XML;
				if(String(node.@unitseq)!="")
				{
					unitSeq=int(String(node.@unitseq))-1;
				}
				if(counter>0)
				{
					if(unitSeq<counter)
					{
						throw new Error("Invalid unitseq tag in firstTimeDefaultSet.");
					}
				}
				if(type=="unit" && !node.hasOwnProperty("@unitroot"))
				{
					throw new Error("Missing unit root tag in firstTimeDefaultSet.");
				}
				if(unitRoot!="")
				{
					//unitRoot=unitRoot+"["+unitSeq.toString()+"]";
					unitNode=LudoUtils.xmlMapper().getNodeByXpath(unitRoot)[unitSeq];
				}
				var fromRootNode:XML;
				var toRootNode:XML;
				var toRoot:String=String(node.@toroot);
				var toKeepRoot:String=String(node.@toroot);
				if(String(node.@fromroot)!="")
				{
					fromRootNode=LudoUtils.xmlMapper().getNodeByXpath(String(node.@fromroot))[0];
				}
				if(unitNode==null && unitRoot!="") toRoot=toRoot==""?unitRoot:unitRoot+"/"+toRoot;
				if(toRoot!="")
				{
					toRootNode=unitNode!=null?XMLMapper.getNodeByXpathAndRootNode(unitNode,toRoot)[0]:LudoUtils.xmlMapper().getNodeByXpath(toRoot)[0];
				}
				else
				{
					toRootNode=unitNode;
				}
				//2nd loop to copy
				for each (var copy:XML in node.copy)
				{
					var fromtag:String=String(copy.@from);
					var totag:String=String(copy.@to);
					if(fromtag!="" && totag!="")
					{
						var fromnode:XML=fromRootNode!=null?XMLMapper.getNodeByXpathAndRootNode(fromRootNode,fromtag)[0]:LudoUtils.xmlMapper().getNodeByXpath(fromtag)[0];
						if(fromnode!=null)
						{
							var fromvalue:String=XMLMapper.getNodeValue(fromnode);
							if(fromvalue!="")
							{
								if(toRootNode==null && unitNode==null && unitRoot!="")
								{
									if(unitSeq>0)
									{
										//get first node if any
										var node:XML=LudoUtils.xmlMapper().getNodeByXpath(keepRoot)[0];
										if(node!=null)
										{
											unitNode=XMLUtils.generateBlankXmlTemplate(node);
											(node.parent() as XML)[unitSeq]=unitNode;
										}
										if(unitNode!=null) toRoot=toKeepRoot;
										if(toRoot!="")
										{
											toRootNode=unitNode!=null?XMLMapper.getNodeByXpathAndRootNode(unitNode,totag)[0]:LudoUtils.xmlMapper().getNodeByXpath(toRoot)[0];
										}
										else
										{
											toRootNode=unitNode;
										}
									}
								}
								if(String(node.@toroot)!="" && toRootNode==null)
								{
									toRootNode=LudoUtils.xmlMapper().createXmlNodeByPathAtRoot(String(node.@toroot));
								}
								var tonode:XML=toRootNode!=null?XMLMapper.getNodeByXpathAndRootNode(toRootNode,totag)[0]:LudoUtils.xmlMapper().getNodeByXpath(totag)[0];
								if(tonode==null)
								{
									tonode=toRootNode!=null?XMLMapper.createXmlNodeByPath(toRootNode,totag)[0]:LudoUtils.xmlMapper().createXmlNodeByPathAtRoot(totag)[0];
								}
								if(tonode!=null )
								{
									if(XMLMapper.getNodeValue(tonode)=="")
									{
										XMLMapper.setValueToNode(tonode,fromvalue);
									}
									else
									{
										break;
									}								
								}
							}
						}
					}
					else
					{
						throw new Error("Improper tag. Missing 'from' or 'to' value.");
					}
				}
				counter++;
			}
		}
		*/
		public function setDefaultToUnit(firstTimeDefaultSet:String,unit:XML,unitSeq:int=0):Boolean
		{
			var defaultSet:Boolean=false;
			if(unit==null){throw new Error("Null unit not allowed.")};
			var fieldSets:XMLList=getFieldSets(firstTimeDefaultSet);
			if(fieldSets==null){throw new Error("Invalid firstTimeDefaultSet.")};
			if(fieldSets.length()>unitSeq)
			{
				var node:XML=fieldSets[unitSeq];
				if(node==null){throw new Error("Invalid firstTimeDefaultSet.")};
				var fromRootNode:XML;
				var toRootNode:XML;
				var toRoot:String=String(node.@toroot);
				if(String(node.@fromroot)!="")
				{
					fromRootNode=LudoUtils.xmlMapper.getNodeByXpath(String(node.@fromroot))[0];
				}
				if(toRoot!="")
				{
					toRootNode=XMLMapper.getNodeByXpathAndRootNode(unit,unit.parent()==null?unit.name().toString()+"/"+toRoot:toRoot)[0];
				}
				else
				{
					toRootNode=unit;
				}
				for each (var copy:XML in node.copy)
				{
					var fromtag:String=String(copy.@from);
					var totag:String=String(copy.@to);
					if(fromtag!="" && totag!="")
					{
						var fromnode:XML=fromRootNode!=null?XMLMapper.getNodeByXpathAndRootNode(fromRootNode,fromtag)[0]:LudoUtils.xmlMapper.getNodeByXpath(fromtag)[0];
						if(fromnode!=null)
						{
							var fromvalue:String=XMLMapper.getNodeValue(fromnode);
							if(fromvalue!="")
							{
								var tonode:XML=toRootNode!=null?XMLMapper.getNodeByXpathAndRootNode(toRootNode,totag)[0]:LudoUtils.xmlMapper.getNodeByXpath(totag)[0];
								if(tonode!=null )
								{
									if(XMLMapper.getNodeValue(tonode)=="")
									{
										XMLMapper.setValueToNode(tonode,fromvalue);
										defaultSet=true;
									}
									else
									{
										break;
									}								
								}
							}
						}
					}
					else
					{
						throw new Error("Improper tag. Missing 'from' or 'to' value.");
					}
				}
			}
			return defaultSet;
		}
		public function setDefaultOld(firstTimeDefaultSet:String):void
		{
			var node:XML=getFieldSets(firstTimeDefaultSet)[0];
			if(node==null){throw new Error("Invalid firstTimeDefaultSet.")};
			var fromRootNode:XML;
			var toRootNode:XML;
			if(String(node.@fromroot)!="")
			{
				fromRootNode=LudoUtils.xmlMapper.getNodeByXpath(String(node.@fromroot))[0];
			}
			if(String(node.@toroot)!="")
			{
				toRootNode= LudoUtils.xmlMapper.getNodeByXpath(String(node.@toroot))[0];
			}
			//2nd loop to copy
			for each (var copy:XML in node.copy)
			{
				var fromtag:String=String(copy.@from);
				var totag:String=String(copy.@to);
				if(fromtag!="" && totag!="")
				{
					var fromnode:XML=fromRootNode!=null?XMLMapper.getNodeByXpathAndRootNode(fromRootNode,fromtag)[0]:LudoUtils.xmlMapper.getNodeByXpath(fromtag)[0];
					if(fromnode!=null)
					{
						var fromvalue:String=XMLMapper.getNodeValue(fromnode);
						if(fromvalue!="")
						{
							var tonode:XML=toRootNode!=null?XMLMapper.getNodeByXpathAndRootNode(toRootNode,totag)[0]:LudoUtils.xmlMapper.getNodeByXpath(totag)[0];
							if(tonode!=null )
							{
								if(XMLMapper.getNodeValue(tonode)=="")
								{
									XMLMapper.setValueToNode(tonode,fromvalue);
								}
								else
								{
									break;
								}								
							}
						}
					}
				}
				else
				{
					throw new Error("Improper tag. Missing 'from' or 'to' value.");
				}
			}
		}
        public function FirstTimeDefault() {
            if (firstTimeDefault != null) {
                throw new Error("Only one FirstTimeDefault instance may be instantiated.");
            }
        }
     }
}