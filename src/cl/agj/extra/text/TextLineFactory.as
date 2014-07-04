package cl.agj.extra.text {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;
	import flashx.textLayout.factory.StringTextLineFactory;
	import flashx.textLayout.formats.TextLayoutFormat;
	/**
	 * ...
	 * @author agj
	 */
	public class TextLineFactory {
		
		public var textLine:TextLine;
		public var textFormat:TextLayoutFormat;
		
		private var factory:StringTextLineFactory;
		
		public function TextLineFactory(textFormat:TextLayoutFormat) {
			this.textFormat = textFormat;
			
			factory = new StringTextLineFactory;
		}
		
		public function makeTextLine(text:String):void {
			factory.compositionBounds = new Rectangle(0, 0, 10000, 5000);
			factory.spanFormat = textFormat;
			factory.text = text;
			factory.createTextLines(getTextLine);
		}
		
		protected function getTextLine(line:TextLine):void {
			textLine = line;
		}
		
	}

}