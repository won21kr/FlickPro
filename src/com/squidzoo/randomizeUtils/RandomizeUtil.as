package com.squidzoo.randomizeUtils
{
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;

	public class RandomizeUtil
	{
		public function RandomizeUtil()
		{
		}
		
		/*
		* http://www.daveoncode.com/2009/01/08/implementing-arrayshuffle-in-actionscript/
		*/
		
		public static function doRandomSortonArray(arr:Array):Array{
			var arr2:Array = [];
			while (arr.length > 0) {
				arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			return arr;
		}
		
		
			
		public static function doRandomSortonArrayCollection(ac:ArrayCollection):ArrayCollection {
				
			function randomCompare(a:Object, b:Object, fields:Array = null):int {
				return Math.round(Math.random()*-1+Math.random());
			}
				
			var sort:Sort = new Sort();
			sort.compareFunction = randomCompare;
			ac.sort = sort;
			ac.refresh();
				
			return ac;
		}
		
		/*
		* http://www.flashandmath.com/howtos/deal/
		*/
		
		public static function getHand(arr:Array,returnQuantity:int):Array {
			var i:int;
			var rand:int;
			
			// Make a temporary array that initially matches the arr array.
			var temp:Array = arr.concat();
			
			// The hand array starts off empty but will eventually contain k cards.
			var hand:Array = new Array();
			
			for (i=0; i<returnQuantity; i++) {
				// If temp contains no elements, we are not going to be able to choose any more cards, so we get out of the loop.
				if (temp.length == 0) break;
				
				// Get a random number from 0, 1, 2, ..., (length of temp array)-1. These are simply all the legit indices for the temp array.
				rand = Math.floor(temp.length * Math.random());
				
				// Put the element at temp[rand] into the hand array and remove it from the temp array.
				hand.push(temp.splice(rand,1)[0]);
			}
			return hand;
		}

	}
}