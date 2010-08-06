package org.ludo.utils
{
	import memorphic.xpath.XPathQuery;
	
	import org.common.utils.XStringUtil;
	import org.common.utils.XXMLUtils;
	
	public class XMLMapper
	{
		private var xmltomap:XML;
		private var rootpath:String="";
		
		public function XMLMapper(xmltomap:XML,rootpath:String="")
		{
			this.xmltomap=xmltomap;
			this.rootpath=rootpath;
		}
		public function set xmlToMap(xmltomap:XML):void
		{
			this.xmltomap=xmltomap;
		}
		public static function getNodeByXpathAndRootNode(xml:XML,xpath:String):*
		{
			if(xml!=null)
			{
				try
				{
					return new XPathQuery(xpath).exec(xml);
				}
				catch(e:Error)
				{
					throw new Error("XPath error for "+xpath+"--",e);
				}
				
			}
			else
			{
				throw new Error("No XML to map.");
			}	
		}
		public function getNodeByXpath(xpath:String,dataFilter:String=""):*
		{
			if(xmltomap!=null)
			{
				if(this.rootpath!="")
				{
					if(dataFilter!="")
					{
						xpath=xpath+"["+dataFilter+"]";
					}
					xpath=this.rootpath+"/"+xpath;
				}
				try
				{
					return new XPathQuery(xpath).exec(xmltomap);
				}
				catch(e:Error)
				{
					throw new Error("XPath error for "+xpath+"--",e);
				}
			}
			else
			{
				throw new Error("No XML to map.");
			}	
		}
		public function getRootNode():*
		{
			if(xmltomap!=null)
			{
				return new XPathQuery(this.rootpath).exec(xmltomap);
			}
			else
			{
				throw new Error("No XML to map.");
			}	
		}
		public static function getNodeValue(node:XML):String
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
		public function setValueToNodeByXpath(xpath:String,value:String):void
		{
			setValueToNode(this.getNodeByXpath(xpath),value);	
		}
		public static function setValueToNode(node:XML,value:String):void
		{
			if(node!=null)
			{
				switch(node.nodeKind())
				{
					case 'attribute':
						node.parent()[node.name()]=value;
						break;
					default:
						node.parent().children()[node.childIndex()]=value;
						break
				}
			}		
		}
		public function getNodeValueByXpath(xpath:String):String
		{
			return 	getNodeValue(getNodeByXpath(xpath));
		}
		public static function getNodeValueByXpathAndRootNode(xml:XML,xpath:String):String
		{
			return 	getNodeValue(getNodeByXpathAndRootNode(xml,xpath));
		}
		public static function updateNode(node:XML,stringToUpdate:String):void
		{
			if(node!=null)
			{
				node.parent().children()[node.childIndex()]=stringToUpdate;
			}		
		}
		private static function parseChildPath(curpath:String,childpath:String):Array
		{

			if(curpath.charAt(curpath.length-1)=="]")
			{
				childpath=curpath.substring(curpath.lastIndexOf("["),curpath.length)+"/"+childpath;
				curpath=curpath.substring(0,curpath.lastIndexOf("["));
				
			}
			/*
			if(childpath.charAt(0)=="[")
			{
				//"InsuredOrPrincipal[InsuredOrPrincipalInfo/InsuredOrPrincipalRoleCd='Insured']/InsuredOrPrincipalInfo/PersonInfo/MiscParty[MiscPartyInfo/MiscPartyRoleCd='Employer']/GeneralPartyInfo/NameInfo/CommlName/CommercialName";
				childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+childpath;
			}
			else
			{
				childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+"/"+childpath;
			}
			*/
			//do again tofind "/"
			childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+"/"+childpath;
			curpath=curpath.substring(0,curpath.lastIndexOf("/"));
			/*
			if(curpath.charAt(curpath.length-1)=="]")
			{
				childpath=curpath.substring(curpath.lastIndexOf("["),curpath.length)+"/"+childpath;
				curpath=curpath.substring(0,curpath.lastIndexOf("["));
			}
			*/
			return [curpath,childpath];
		}
		public static function createXmlNodeByPath(xml:XML,xpath:String,findbychildtag:String=""):XML
		{
			//var parentNode : Object = xml;
			var currentNode : XMLList;
			var oldpath:String=xpath;
			var filterArray:Array=[];
			var filtertag:String="";
			var childmap:String="";
			var filter:Boolean=false;
			var loppcount:int=0;
			var exitloop:Boolean=false;
			var addedattribute:String="";
			
			if(findbychildtag!="")
			{
				filterArray=findbychildtag.split("^");
				if(filterArray.length>0)
				{
					filtertag=filterArray[0];
					xpath=filtertag;
					filter=true;
				}
				if(filterArray.length>1)
				{
					childmap=filterArray[1];
				}
			}
			if(xpath!="")
			{
				//xpath=("/"+xpath).replace("//","/");
				//if(xpath.indexOf("/") != - 1)
				//{
					var curpath:String=xpath;
					var childpath:String="";
					//while(curpath.indexOf("/")!=-1)
					while(!exitloop)
					{
						if(curpath=="")
						{
							exitloop=true;
						}
						//if filter, dont look for parent, look for grand parent
						if(filter && loppcount==1)
						{
							var parsedPath0:Array=parseChildPath(curpath,childpath);
							childpath=parsedPath0[1];
							curpath=parsedPath0[0];
							//childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+"/"+childpath;
							//curpath=curpath.substring(0,curpath.lastIndexOf("/"));							
						}
						if(curpath=="")
						{
							currentNode=XMLList(xml);
						}
						else
						{
							currentNode=getNodeByXpathAndRootNode(xml,curpath)
						}
						//if(currentNode.length()>0)
						if(currentNode.length()==1)
						{
							if(childpath!="")
							{
								currentNode=addElementByPath(currentNode,childpath);
							}
							break;
						}
						else
						{
							var parsedPath:Array=parseChildPath(curpath,childpath);
							childpath=parsedPath[1];
							curpath=parsedPath[0];
							/*
							if(childpath.charAt(0)=="[")
							{
								//"InsuredOrPrincipal[InsuredOrPrincipalInfo/InsuredOrPrincipalRoleCd='Insured']/InsuredOrPrincipalInfo/PersonInfo/MiscParty[MiscPartyInfo/MiscPartyRoleCd='Employer']/GeneralPartyInfo/NameInfo/CommlName/CommercialName";
								childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+childpath;
							}
							else
							{
								childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+"/"+childpath;
							}
							curpath=curpath.substring(0,curpath.lastIndexOf("/"));
							if(curpath.charAt(curpath.length-1)=="]")
							{
								childpath=curpath.substring(curpath.lastIndexOf("["),curpath.length)+"/"+childpath;
								curpath=curpath.substring(0,curpath.lastIndexOf("["));
							}
							trace(childpath);
							trace(curpath);
							*/
						}
						loppcount++;
					}
				//}
				
			}
			if(filtertag!="")
			{
				if(currentNode[0]!=null)
				{
					if(childmap!="")
					{
						//child node is null then create node
						var xml:XML=getNodeByXpathAndRootNode((currentNode[0] as XML).parent(),childmap)[0] as XML;
						if(xml==null)
						{
							xml=XMLMapper.addElementByPath((currentNode[0] as XML).parent(),childmap)[0];
						}
						return xml;
						
						//return getNodeByXpathAndRootNode((currentNode[0] as XML).parent(),childmap)[0] as XML;
					}
					else
					{
						return (currentNode[0] as XML).parent();
					}
				}
				else
				{
					return null;
				}
				/*
				if(currentNode[0]!=null)
				{
					if(childmap!="")
					{
						return getNodeByXpathAndRootNode((currentNode[0] as XML).parent(),childmap)[0] as XML;
					}
					else
					{
						return (currentNode[0] as XML).parent();
					}
				}
				else
				{
					return null;
				}
				*/
			}
			else
			{
				return currentNode[0] as XML;

			}
		}

		public function createXmlNodeByPathAtRoot(xpath:String,findbychildtag:String=""):XML
		{
			//var parentNode : Object = xml;
			var currentNode : XMLList;
			var oldpath:String=xpath;
			var filterArray:Array=findbychildtag.split("^");
			var filtertag:String="";
			var childmap:String="";
			var filter:Boolean=false;
			var loppcount:int=0;
			var exitloop:Boolean=false;
			var addedattribute:String="";
			
			if(findbychildtag!="" && filterArray.length>0)
			{
				filtertag=filterArray[0];
				xpath=filtertag;
				filter=true;
			}
			if(filterArray.length>1)
			{
				childmap=filterArray[1];
			}			
			if(xpath!="")
			{
				//if(xpath.indexOf("/") != - 1)
				//{
					var curpath:String=xpath;
					var childpath:String="";
					//while(curpath.indexOf("/")!=-1)
					while(!exitloop)
					{
						if(curpath=="")
						{
							exitloop=true;
							curpath="/";
						}
						//if filter, dont look for parent, look for grand parent
						if(filter && loppcount==1)
						{
							var parsedPath0:Array=XMLMapper.parseChildPath(curpath,childpath);
							childpath=parsedPath0[1];
							curpath=parsedPath0[0];
						//	childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+"/"+childpath;
						//	curpath=curpath.substring(0,curpath.lastIndexOf("/"));							
						}
						if(curpath==""||curpath=="/")
						{
							currentNode=getRootNode();
						}
						else
						{
							currentNode=getNodeByXpath(curpath)
						}
						//if(currentNode.length()>0)
						if(currentNode.length()==1)
						{
							if(childpath!="")
							{
								currentNode=XMLMapper.addElementByPath(currentNode,childpath);
							}
							break;
						}
						else
						{
							var parsedPath:Array=XMLMapper.parseChildPath(curpath,childpath);
							childpath=parsedPath[1];
							curpath=parsedPath[0];
							//childpath=curpath.substring(curpath.lastIndexOf("/")+1,curpath.length)+"/"+childpath;
							//curpath=curpath.substring(0,curpath.lastIndexOf("/"));
						}
						loppcount++;
					}
				//}
				
			}
			if(filtertag!="")
			{
				if(currentNode[0]!=null)
				{
					if(childmap!="")
					{
						//child node is null then create node
						var xml:XML=getNodeByXpathAndRootNode((currentNode[0] as XML).parent(),childmap)[0] as XML;
						if(xml==null)
						{
							xml=XMLMapper.addElementByPath((currentNode[0] as XML).parent(),childmap)[0];
						}
						return xml;
						
						//return getNodeByXpathAndRootNode((currentNode[0] as XML).parent(),childmap)[0] as XML;
					}
					else
					{
						return (currentNode[0] as XML).parent();
					}
				}
				else
				{
					return null;
				}
			}
			else
			{
				return currentNode[0] as XML;
				/*
				if(addedattribute!="")
				{
					return currentNode as XML;
				}
				else
				{
					return currentNode[0] as XML;
				}
				*/
			}	
		}

		private static function newXmlList(nodeName:String,nodeValue:String=""):XMLList
		{
			return XMLList(XXMLUtils.createXMLNode(nodeName,nodeValue));
			/*
			if(nodeValue!="")
			{
				return XMLList(<{nodeName}>{nodeValue}</{nodeName}>);

				//return XMLList("<"+nodeName+">"+nodeValue+"</"+nodeName+">");
			}
			else
			{
				return XMLList(<{nodeName}/>);
				//return XMLList("<"+nodeName+"/>");
			}
			*/
		}
		private static function addElementByPathOld(currentNode:*,childpath:String):XMLList
        {
        	//var currentNode:XML=new XML();
        	var blnattr:Boolean=false;
			if(childpath.indexOf("/") == - 1)
			{
				if(childpath != "")
				{
					childpath=childpath+"/";
				}
			}	
			if(childpath.indexOf("/") != - 1)
			{
				var fields:Array = childpath.split("/");
				var startbrace:Boolean=false;
        		var childtag:Boolean=false;
        		//rootNode.appendChild(currentNode);
        		//currentNode=currentNode.parent().children()[currentNode.childIndex()]
        		for each(var f : String in fields)
				{

					var arrAttr:Array=[];
					startbrace=false;
					if(f!="")
					{
						if(blnattr)
						{
							throw new Error("Invalid xpath "+childpath+"/@attribute is allowed at the end only!");
						}
		        		if(f.indexOf("[")!=-1)
		        		{
		        			startbrace=true;
		        		}
		        		if(f.indexOf("]")!=-1)
		        		{
		        			var arrayName:Array=f.substring(0,f.length-1).split("[");
		        			if(arrayName.length==2)
		        			{
		        				f=arrayName[0];
		        				//parse attributes assuming only one attribute..
		        				//need to work on later for multiple attribute
		        				arrAttr=String(arrayName[1]).split("=");
		        				if(arrAttr.length!=2)
		        				{
		        					throw new Error("Invalid xpath parameter.");
		        				}
		        			}
		        			else
		        			{
		        				throw new Error("Missing '[' in xpath.");
		        			}
		        		}
		        		else
		        		{
		        			if(startbrace)
		        			{
		        				throw new Error("Missing ']' in xpath.");
		        			}
		        		}
						var newNode:XMLList;
						if(arrAttr.length==2)
						{
							
							var att:String=arrAttr[0].toString();
							var val:String=arrAttr[1].toString();
							if(att.indexOf("@",0)==0)
							{
								att = att.substr(1);
							}
							else if(att=='.')
							{
								childtag=true;
							}
							else
							{
								throw new Error("Invalid attribute, missing '@' at the begining.");
							}
							var exp:RegExp=/".*"|'.*'$///quoted string
							if(XStringUtil.validStringByRegExp(val,exp))
							{
								//strip quotes
								val = val.substr(1,val.length-2);
							}
							if(childtag)
							{
								//check if blank node is there whiel creating
								newNode=newXmlList(f,val);
								currentNode.appendChild(newNode);
								//currentNode[f]="";
								//currentNode=currentNode[f][0];
								currentNode=newNode;
								//currentNode[f]=val;
								//currentNode=currentNode.child(f)[0];
								//currentNode=currentNode[f];
								childtag=false;
							}
							else
							{			
								newNode=newXmlList(f,val);
								currentNode.appendChild(newNode);
								//currentNode[f]="";
								//currentNode=currentNode[f][0];
								currentNode=newNode;
								//currentNode[f]="";
								//currentNode=currentNode[f];
								//currentNode=currentNode.child(f)[0];
								currentNode.@[att]=val;
							}
						}
						else
						{
							if(f.indexOf("@",0)==0)//attribute
							{
								currentNode.@[f.substr(1)]='';
								currentNode=getNodeByXpathAndRootNode(currentNode,f);
								blnattr=true;
							}
							else
							{
								newNode=newXmlList(f);
								currentNode.appendChild(newNode);
								currentNode=newNode;
							}
						}
						
					}
				}
			}
			if(currentNode is XML)
			{
				return XMLList(currentNode);
			}
			return currentNode;
        }

		private static function addElementByPath(currentNode:*,childpath:String):XMLList
        {
        	//var currentNode:XML=new XML();
        	var blnattr:Boolean=false;
			if(childpath.indexOf("/") == - 1)
			{
				if(childpath != "")
				{
					childpath=childpath+"/";
				}
			}	
			if(childpath.indexOf("/") != - 1)
			{
				var fields:Array = childpath.split("/");
				var startbrace:Boolean=false;
				var createtag:Boolean=false;
        		var childtag:Boolean=false;
        		var xmltag:String="";
        		var searchtag:String="";
        		//rootNode.appendChild(currentNode);
        		//currentNode=currentNode.parent().children()[currentNode.childIndex()]
        		for each(var f : String in fields)
				{

					var arrAttr:Array=[];
					if(f!="")
					{
						if(blnattr)
						{
							throw new Error("Invalid xpath "+childpath+"/@attribute is allowed at the end only!");
						}
						//InsuredOrPrincipal[InsuredOrPrincipalInfo/another/InsuredOrPrincipalRoleCd='Insured']/
		        		if(f.indexOf("[")!=-1)
		        		{
							if(startbrace)
							{
								throw new Error("Invalid xpath "+childpath+" some parsing went awry!");
							}
		        			startbrace=true;//search for search path
		        			//get the xmltag to be created
		        			var arrayTag:Array=f.split("[");
		        			xmltag=arrayTag[0];
		        			searchtag=arrayTag[1];
		        			createtag=true;
		        		}
		        		else if(startbrace)//there is a start brace
	        			{
	        				//create search path
	        				searchtag=searchtag+"/"+f;
	        			}
		        		if(!startbrace)
		        		{
		        			createtag=true;
		        			xmltag=f;
		        		}
						if(createtag)
						{
							if(xmltag!="")
							{
								var newNode:XMLList;
								if(xmltag.indexOf("@",0)==0)//attribute
								{
									currentNode.@[xmltag.substr(1)]='';
									currentNode=getNodeByXpathAndRootNode(currentNode,xmltag);
									blnattr=true;
								}
								else
								{
									newNode=newXmlList(xmltag);
									currentNode.appendChild(newNode);
									currentNode=newNode;
								}
							}
							createtag=false;
							xmltag="";
						}
						//search for ']' tag
		        		if(startbrace && searchtag.indexOf("]")!=-1)
		        		{
		        			//create search path
		        			//InsuredOrPrincipal[InsuredOrPrincipalRoleCd='Insured']/
		        			searchtag=searchtag.substring(0,searchtag.length-1);
		        			//check if attribute
							if(searchtag.indexOf("@",0)==0)//attribute
							{
								var arrAttr2:Array=searchtag.split("=");
								if(arrAttr2.length==2)
								{
									currentNode.@[arrAttr2[0].substr(1)]=XStringUtil.getStringWithoutQuote(arrAttr2[1]);
								}
								else
								{
									throw new Error("Invalid xpath "+searchtag+" some parsing went awry!");
								}
							}
							else
							{
								currentNode.appendChild(createSearchPath(searchtag));
							}
		        			searchtag="";
		        			startbrace=false;
		        		}
					}
				}
				if(startbrace)
				{
					throw new Error("Invalid xpath "+childpath+" some parsing went awry!");
				}				
			}
			if(currentNode is XML)
			{
				return XMLList(currentNode);
			}
			return currentNode;
        }


		private static function createSearchPath(childpath:String):XMLList
        {
        	var currentNode:XML=new XML();
        	if(childpath.indexOf("=") != - 1)
			{
				var fields:Array = childpath.split("/");
				var atttag:Boolean=false;
        		var childtag:Boolean=false;
        		for each(var f : String in fields)
				{ 

					var arrAttr:Array=[];
					if(f!="")
					{
						if(f.indexOf("[")!=-1)
		        		{
		        			throw new Error("Invalid seachpath "+childpath+"/'[' is allowed in search path!");
		        		}
		        		if(f.indexOf("]")!=-1)
		        		{
		        			throw new Error("Invalid seachpath "+childpath+"/']' is allowed in search path!");
		        		}
						//[InsuredOrPrincipalInfo/InsuredOrPrincipalRoleCd='Insured']
						arrAttr=f.split("=");
						var newNode:XMLList;
						if(arrAttr.length==2)
						{
							
							var att:String=arrAttr[0].toString();
							var val:String=arrAttr[1].toString();
							if(att.indexOf("@",0)==0)
							{
								att = att.substr(1);
								atttag=true;
							}
							else if(att=='.')
							{
								childtag=true;
							}
							/*
							var exp:RegExp=/".*"|'.*'$///quoted string
							if(Common.validStringByRegExp(val,exp))
							{
								//strip quotes
								val = val.substr(1,val.length-2);
							}
							*/
							val=XStringUtil.getStringWithoutQuote(val);
							if(childtag)
							{
								//check if blank node is there while creating
								newNode=newXmlList(f,val);
								currentNode.appendChild(newNode);
								currentNode=newNode[0];
								childtag=false;
							}
							else if(atttag)
							{			
								//newNode=newXmlList(f);
								//currentNode.appendChild(newNode);
								//currentNode=newNode[0];
								currentNode.@[att]=val;
								atttag=false;
							}
							else
							{			
								newNode=newXmlList(att,val);
								currentNode.appendChild(newNode);
								currentNode=newNode[0];
							}
						}
						else//just node
						{
							newNode=newXmlList(f);
							currentNode.appendChild(newNode);
							currentNode=newNode[0];
						}
						
					}
				}
			}
			return XMLList(rootNode(currentNode));
        }

		private static function rootNode(node:XML):XML
		{
			var p:XML = node;
			while(p = p.parent()){
				node = p;
			}
			return node;
		}
//*******************************        
	}
}