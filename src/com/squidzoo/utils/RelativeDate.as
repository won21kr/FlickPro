package com.squidzoo.utils
{
	import com.squidzoo.utils.DateUtil;
	
	/**
	 * Utility class to help create human-readable Strings representing
	 * the difference in time from two different dates (e.g. "just now"
	 * or "2 hours ago" or "13 minutes from now").
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0
	 */
	public class RelativeDate
	{
		private static const SECONDS_PER_MINUTE:uint = 60;
		private static const SECONDS_PER_TWO_MINUTES:uint = 120;
		private static const SECONDS_PER_HOUR:uint = 3600;
		private static const SECONDS_PER_TWO_HOURS:uint = 7200;
		private static const SECONDS_PER_DAY:uint = 86400;
		private static const SECONDS_PER_TWO_DAYS:uint = 172800;
		private static const SECONDS_PER_THREE_DAYS:uint = 259200;
		
		/**
		 * Creates a human-readable String representing the difference
		 * in time from the date provided and now.  This method handles
		 * dates in both the past and the future (e.g. "2 hours ago"
		 * and "2 hours from now".  For any date beyond 3 days difference
		 * from now, then a standard format is returned.
		 *
		 * @param date The date for which to compare against.
		 *
		 * @return Human-readable String representing the time elapsed.
		 */
		public static function getRelativeDateFromNow(date:Date, capitalizeFirstLetter:Boolean = false):String
		{
			return getRelativeDate(date, new Date(), capitalizeFirstLetter);
		}
		
		/**
		 * Creates a human-readable String representing the difference
		 * in time from the first date provided with respect to the
		 * second date provided.  If no second date is provided, then
		 * the relative date will be calcluated with respect to "now".
		 * This method handles dates in both the past and the
		 * future (e.g. "2 hours ago" and "2 hours from now".  For
		 * any date beyond 3 days difference from now, then a
		 * standard format is returned.
		 *
		 * @param firstDate The date for which to compare against.
		 * @param secondDate The date to use as "present" when comparing against firstDate.
		 *
		 * @return Human-readable String representing the time elapsed.
		 */
		public static function getRelativeDate(firstDate:Date, secondDate:Date = null, capitalizeFirstLetter:Boolean = false):String
		{
			var relativeDate:String;
			var isFuture:Boolean = false;
			
			if (secondDate == null)
			{
				secondDate = new Date();
			}
			
			// the difference between the passed-in date and now, in seconds
			var secondsElapsed:Number = (secondDate.getTime() - firstDate.getTime()) / 1000;
			
			if (secondsElapsed < 0)
			{
				isFuture = true;
				secondsElapsed = Math.abs(secondsElapsed);
			}
			
			switch(true)
			{
				case secondsElapsed < SECONDS_PER_MINUTE:
					relativeDate = "just now";
					break;
				case secondsElapsed < SECONDS_PER_TWO_MINUTES:
					relativeDate = "1 minute " + ((isFuture) ? "from now" : "ago");
					break;
				case secondsElapsed < SECONDS_PER_HOUR:
					relativeDate = int(secondsElapsed / SECONDS_PER_MINUTE) + " minutes " + ((isFuture) ? "from now" : "ago");
					break;
				case secondsElapsed < SECONDS_PER_TWO_HOURS:
					relativeDate = "about an hour " + ((isFuture) ? "from now" : "ago");
					break;
				case secondsElapsed < SECONDS_PER_DAY:
					relativeDate = int(secondsElapsed / SECONDS_PER_HOUR) + " hours " + ((isFuture) ? "from now" : "ago");
					break;
				case secondsElapsed < SECONDS_PER_TWO_DAYS:
					relativeDate = ((isFuture) ? "tomorrow" : "yesterday") + " at " + DateUtil.getShortHour(firstDate) + ":" + getMinutesString(firstDate) + DateUtil.getAMPM(firstDate).toLowerCase();
					break;
				case secondsElapsed < SECONDS_PER_THREE_DAYS:
					relativeDate = DateUtil.getFullDayName(firstDate) + " at " + DateUtil.getShortHour(firstDate) + ":" + getMinutesString(firstDate) + DateUtil.getAMPM(firstDate).toLowerCase();
					break;
				default:
					relativeDate = DateUtil.getFullMonthName(firstDate) + " " + firstDate.getDate() + " at " + DateUtil.getShortHour(firstDate) + ":" + getMinutesString(firstDate) + DateUtil.getAMPM(firstDate).toLowerCase()
					break;
			}
			
			return ((capitalizeFirstLetter) ? relativeDate.substring(0, 1).toUpperCase() + relativeDate.substring(1, relativeDate.length) : relativeDate);
		}
		
		/**
		 * @private
		 */
		private static function getMinutesString(date:Date):String
		{
			return ((date.minutes < 10) ? "0" : "") + date.minutes;
		}
	}
}