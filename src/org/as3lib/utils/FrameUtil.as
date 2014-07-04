package org.as3lib.utils
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	
	/**
	 * FrameUtil
	 *
	 * @author Mims H. Wright
	 */
	public final class FrameUtil
	{
		public function FrameUtil()
		{
		}
		
		/**
		 * Returns a frame number based on a string label.
		 * 
		 * @param the frame label you're looking for as a string.
		 * @return int number of the frame or throws an error.
		 */
		public static function getFrameNumberFromString(movieClip:MovieClip, matchLabel:String):int {
			var labelList:Array = movieClip.currentLabels;
			var l:int = labelList.length;
			var label:FrameLabel;
			for (var i:int = 0; i < l; i++) {
				label = FrameLabel(labelList[i]);
				if (label.name == matchLabel) {
					return label.frame;
				}
			}
			throw new Error("Invalid label name. The target MovieClip does not contain this label.");
		}
	}
}