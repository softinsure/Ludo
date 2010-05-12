package org.ludo.containers.base
{
	import mx.core.IVisualElement;
	
	import spark.components.SkinnableContainer;
	
	public class BaseContainer extends SkinnableContainer
	{
		public function BaseContainer()
		{
			super();
		}
		public function addToContainer(content:IVisualElement):void
		{
			this.removeAllElements();
			this.addElement(content);
		}
	}
}