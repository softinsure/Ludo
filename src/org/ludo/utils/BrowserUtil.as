package org.ludo.utils
{
	import flash.events.Event;
	
	import mx.events.BrowserChangeEvent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;

    [Bindable]
    public class BrowserUtil
	{
        private static var browserUtil:BrowserUtil;
		private static var browserManager:IBrowserManager;

        public static function getInstance():BrowserUtil {
        	if(browserUtil==null)
        	{
        		if(browserManager == null)
        		{
        			initBrowserManager();
		         }
		         browserUtil = new BrowserUtil();
		       }
         return browserUtil;
        }
 		private static function initBrowserManager():void
 		{
 			browserManager = BrowserManager.getInstance();
            browserManager.addEventListener(BrowserChangeEvent.APPLICATION_URL_CHANGE,logURLChange);
            browserManager.init("", "Welcome!");
			
 		}
        public function updateTitle(title:String):void {
        	if(browserManager == null)
        	{
        		initBrowserManager();
        	}
        	browserManager.setTitle(title);
        }

        public function updateURL(event:Event,object:Object):void {
        	if(browserManager == null)
        	{
        		initBrowserManager();
        	}
        	var s:String = object.name+"=" + event.currentTarget.selectedIndex;
            browserManager.setFragment(s);
        }
        public static function logURLChange(event:BrowserChangeEvent):void {
        	var string:String="APPLICATION_URL_CHANGE event:\n url: " + event.url + "\n prev: " + event.lastURL + "\n";
        }
        
        //The constructor should be private, but this is not
        //possible in ActionScript 3.0. So, throwing an Error if
        //a second LudoModelLocator is created is the best we
        //can do to implement the Singleton pattern.
        public function BrowserUtil() {
            if (browserUtil != null) {
                throw new Error("Only one BrowserUtil instance may be instantiated.");
            }

        }
        public function setBrowserInfo(event:Event,url:Object,title:String=""):void
        {
        	this.updateURL(event,url);
			this.updateTitle(title);        	
        }
	}
}