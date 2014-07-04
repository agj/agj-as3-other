package cl.agj.ui 
{
	
	/**
	 * ...
	 * @author agj
	 */
	public class ButtonFormat {
		
		public static const ALIGN_LEFT:String = "alignLeft";
		public static const ALIGN_RIGHT:String = "alignRight";
		public static const ALIGN_CENTER:String = "alignCenter";
		
		public var color:uint;
		public var font:String;
		public var textSize:Number;
		public var textColor:uint;
		public var margin:Number;
		public var alignment:String;
		public var transparent:Boolean;
		
		public function ButtonFormat(colorValue:Object = null, fontName:Object = null, textSizeValue:Object = null, textColorValue:Object = null, marginValue:Object = null, alignmentString:Object = null, transparentBoolean:Object = null) {
			if (colorValue is uint) color = uint(colorValue);
			if (fontName is String) font = String(fontName);
			if (textSizeValue is Number) textSize = Number(textSizeValue);
			if (textColorValue is uint) textColor = uint(textColorValue);
			if (marginValue is Number) margin = Number(marginValue);
			if (alignmentString is String) alignment = String(alignmentString);
			if (transparentBoolean is Boolean) transparent = transparentBoolean;
		}
		
	}
	
}