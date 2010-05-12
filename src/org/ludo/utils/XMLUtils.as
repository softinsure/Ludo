package org.ludo.utils
{
	public class XMLUtils
	{
		public function XMLUtils()
		{
		}
		public static function xmlListToBoolean(xmlList : XMLList) : Boolean
		{
			return xmlList.toString() == "true";
		}
		public static function setBlankAttributeValue(node : XML):void
		{
			if (node.nodeKind() == "element")
			{
				for each (var attribute : XML in node.@ * )
				{
					node.@[attribute.name().toString()] = "";
				}
			}
		}
		public static function generateBlankXmlTemplate(xml:XML,donotblanknodetag:String=""):XML
		{
			var node:XML = xml.copy();
			var donotblank:XMLList;
			setBlankAttributeValue(node);
			if(node.hasOwnProperty(donotblanknodetag))
			{
				donotblank=node.elements(donotblanknodetag).copy();	
			} 
			for each (var childnode:XML in node.. * )
			{
				if (childnode.nodeKind() == 'text')
				{
					setNodeValue(childnode , '');
				}
				setBlankAttributeValue(childnode);
			}
			if(node.hasOwnProperty(donotblanknodetag))
			{
				node.replace(donotblanknodetag,donotblank);
			}
			return node;
		}
		public static function createXMLNode(tagName:String,content:String,attributeName:String="",attributeValue:String=""):XML
		{
			// Create the XML object using the values provided
			// by the user for the tag name, attribute name,
			// attribute value and the tag's contents.
			if(attributeName!="")
			{
				return <{tagName} {attributeName}={attributeValue}>{content}</{tagName}>;
			}
			else
			{
				return <{tagName}>{content}</{tagName}>;
			}
		}
		public static function setNodeValue(node : XML , stringToUpdate : String) : void
		{
			if(node != null)
			{
				node.parent().children()[node.childIndex()] = stringToUpdate;
			}
		}
	}
}