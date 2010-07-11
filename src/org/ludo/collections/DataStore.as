/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: DataStore.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.collections
{
	import org.frest.collections.DataContainer;
	import org.ludo.views.SearchBox;
	
	[Bindable]
	/**
	 * storage of data containers used in LUDO.
	 * @author Goutam
	 * 
	 */
	public class DataStore
	{
		private static var xmlContainer:DataContainer;
		private static var pageContainer:DataContainer;
		private static var dataMapContainer:DataContainer;
		private static var xmlMapContainer:DataContainer;
		private static var unitXmlMapContainer:DataContainer;
		private static var validatorContainer:DataContainer;
		private static var coverageContainer:DataContainer;
		private static var objectMapContainer:DataContainer;
		private static var initFuncContainer:DataContainer;
		//private static var searchBoxContainer:DataContainer;
		//private static var session:DataContainer;
		//Singleton stuff
        //
        private static var dataStore:DataStore;

        public static function getInstance():DataStore{
            if (dataStore == null) {
                dataStore = new DataStore();
                xmlContainer = new DataContainer();
                pageContainer = new DataContainer();
                dataMapContainer = new DataContainer();
                xmlMapContainer = new DataContainer();
                unitXmlMapContainer = new DataContainer();
                validatorContainer = new DataContainer();
                coverageContainer = new DataContainer();
                objectMapContainer = new DataContainer();
                initFuncContainer = new DataContainer();
                //searchBoxContainer = new DataContainer();
                //session = new DataContainer();
            }
            return dataStore;
        }
        public function DataStore() {
            if (dataStore != null) {
                throw new Error("Only one DataStore instance may be instantiated.");
            }
        }
		/**
		 * use this method to add xml to store by key 
		 * @param key
		 * @param xml
		 * 
		 */
		public function cleanDataStore():void
		{
			dataStore=null;
			/*
			emptyPageContainer();
			emptyXmlMapContainer();
			emptyDataMapContainer();
			emptyUnitXmlMapContainer();
			emptyValidatorContainer();
			emptyInitFuncContainer();
			emptyObjectMapContainer();
			emptyCoverageContainer();
			*/
			
		}
		public function addToXmlContainer(key:String,xml:XML) : void
		{
			xmlContainer.put(key,xml);
		}
		public function getFromXmlContainer(key:String) : XML
		{
			return xmlContainer.get(key);
		}
		/**
		 * use this method to get xml from store by key  
		 * @param key
		 * @param array
		 * 
		 */
		public function addToPageContainer(key:String,array:Array) : void
		{
			pageContainer.put(key,array);
		}
		public function getFromPageContainer(key:String) : Array
		{
			return pageContainer.get(key);
		}
		public function addToDataMapContainer(key:String,array:Array) : void
		{
			dataMapContainer.put(key,array);
		}
		public function getFromDataMapContainer(key:String) : Array
		{
			return dataMapContainer.get(key);
		}
		public function addToValidatorContainer(key:String,array:Array) : void
		{
			validatorContainer.put(key,array);
			
		}
		public function getFromValidatorContainer(key:String) : Array
		{
			return validatorContainer.get(key);
		}
		public function addToCoverageContainer(key:String,array:Array) : void
		{
			coverageContainer.put(key,array);
			
		}
		public function getFromCoverageContainer(key:String) : Array
		{
			return coverageContainer.get(key);
		}
		public function addToXmlMapContainer(key:String,array:Array) : void
		{
			xmlMapContainer.put(key,array);
			
		}
		public function getFromXmlMapContainer(key:String) : Array
		{
			return xmlMapContainer.get(key);
		}
		public function addToUnitXmlMapContainer(key:String,array:Array) : void
		{
			unitXmlMapContainer.put(key,array);
			
		}
		public function getFromUnitXmlMapContainer(key:String) : Array
		{
			return unitXmlMapContainer.get(key);
		}
		public function addToObjectMapContainer(key:String,container:Array) : void
		{
			objectMapContainer.put(key,container);
			
		}
		public function getObjectMapContainer(key:String) : Array
		{
			return objectMapContainer.get(key);
		}	
		public function addToInitFuncContainer(key:String,initFunc:Function) : void
		{
			initFuncContainer.put(key,initFunc);
			
		}
		public function getFromInitFuncContainerContainer(key:String) : Function
		{
			return initFuncContainer.get(key);
		}
		/*
		public function addToSearchBoxContainer(key:String,searchox:SearchBox) : void
		{
			searchBoxContainer.put(key,searchox);
			
		}
		
		public function getFromsearchBoxContainer(key:String):SearchBox
		{
			return searchBoxContainer.get(key);
		}
		*/
		public static function addToAnyContainer(container:DataContainer,key:String,value:*) : void
		{
			container.put(key,value);
			
		}
		public static function getFromAnyContainer(container:DataContainer,key:String) : *
		{
			return container.get(key);
		}
		/*
		public function setSession(key:String,value:*) : void
		{
			session.put(key,value);
		}
		
		public function getSession(key:String) : *
		{
			return session.get(key);
		}
		*/
		public function emptyXmlMapContainer():void
		{
			emptyContainer(xmlMapContainer);
		}
		public function emptyDataMapContainer():void
		{
			emptyContainer(dataMapContainer);
		}
		public function emptyInitFuncContainer():void
		{
			emptyContainer(initFuncContainer);
		}
		public function emptyUnitXmlMapContainer():void
		{
			emptyContainer(unitXmlMapContainer);
		}
		public function emptyXmlContainer():void
		{
			emptyContainer(xmlContainer);
		}
		/*
		public function emptysSession():void
		{
			emptyContainer(session);
		}
		*/
		public function emptyPageContainer():void
		{
			emptyContainer(pageContainer);
		}
		public function emptyValidatorContainer():void
		{
			emptyContainer(validatorContainer);
		}
		public function emptyCoverageContainer():void
		{
			emptyContainer(coverageContainer);
		}
		public function emptyObjectMapContainer():void
		{
			emptyContainer(objectMapContainer);
		}
		/*
		public function emptySearchBoxContainer():void
		{
			emptyContainer(searchBoxContainer);
		}
		*/
		private function emptyContainer(container:DataContainer):void
		{
			container.empty()
		}
	}
}
