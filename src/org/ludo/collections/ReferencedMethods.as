/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: ReferencedMethods.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.collections
{
	/**
	 * this singletone objects is used to store referenced functions by key. stored functions can
	 * be called by their referenced keys
	 * @author SoftInsure
	 * 
	 */
	public class ReferencedMethods extends Object
	{
		private static var referencedMethods:ReferencedMethods;
		private static var methods:Array;
		public static function getInstance():ReferencedMethods{
			if (referencedMethods == null)
			{
				referencedMethods = new ReferencedMethods();
				methods=[];
			}
			return referencedMethods;
		}
		public function ReferencedMethods()
		{
			if (referencedMethods != null)
			{
				throw new Error("Only one ReferencedMethods instance may be instantiated.");
			}
		}
		/**
		 * get referenced method by hask key 
		 * @param hashkey
		 * @return 
		 * 
		 */
		public function getMethod(hashkey:String):Function
		{
			if(contains(hashkey))
			{
				return methods[hashkey.toLowerCase()];
			}
			else
			{
				throw new Error("Missing function in ReferencedMethods for hash key "+hashkey+"! Please use reference method to use this functionality.");
			}
		}
		/**
		 * call refferenced method by hash key 
		 * @param hashkey
		 * @param params
		 * @return 
		 * 
		 */
		public function callMethod(hashkey:String,...params):*
		{
			if(contains(hashkey))
			{
				return (methods[hashkey.toLowerCase()] as Function).apply(null,params);
			}
			else
			{
				throw new Error("Missing function in ReferencedMethods for hash key "+hashkey+"! Please use reference method to use this functionality.");
			}
		}
		/**
		 * reference a method by hash key 
		 * @param hashkey
		 * @param method
		 * 
		 */
		public function referenceMethod(hashkey:String,method:Function):void
		{
			remove(hashkey);
			methods[hashkey.toLowerCase()]=method;
		}
		/**
		 * used to check if a method is referenced 
		 * @param hashkey
		 * @return 
		 * 
		 */
		public function contains(hashkey:String):Boolean
		{
			return (methods[hashkey.toLowerCase()] != null);
		}
		/**
		 * used to remove method from referenced array 
		 * @param hashkey
		 * 
		 */
		public function remove(hashkey:String):void
		{
			if(this.contains(hashkey))
			{
				methods[hashkey]=null;
				delete methods[hashkey];
			}
		}
	}
}