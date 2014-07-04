package cl.agj.extra.text {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;
	import flashx.textLayout.factory.StringTextLineFactory;
	import flashx.textLayout.formats.TextLayoutFormat;
	/**
	 * ...
	 * @author agj
	 */
	public class BitmapTextFactory {
		
		public var textFormat:TextLayoutFormat;
		public var bitmapText:BitmapData;
		public var transparent:Boolean;
		public var backgroundColor:uint;
		
		private var factory:StringTextLineFactory;
		
		public function BitmapTextFactory(fontFamily:String = "_sans", fontSize:Number = 12, textColor:uint = 0, transparent:Boolean = true, backgroundColor:uint = 0xffffff) {
			textFormat = new TextLayoutFormat;
			textFormat.fontFamily = fontFamily;
			textFormat.fontSize = fontSize;
			textFormat.color = textColor;
			
			this.transparent = transparent;
			this.backgroundColor = backgroundColor;
			
			factory = new StringTextLineFactory;
		}
		
		public function makeBitmapText(text:String):void {
			factory.compositionBounds = new Rectangle(0, 0, 5000, 5000);
			factory.spanFormat = textFormat;
			factory.text = text;
			factory.createTextLines(getTextLine);
		}
		
		private function getTextLine(line:TextLine):void {
			if (bitmapText) bitmapText.dispose();
			var lineSprite:Sprite = new Sprite;
			//var lineSprite:Sprite = Sprite(line);
			lineSprite.addChild(line);
			bitmapText = new BitmapData(line.width, line.height, transparent, backgroundColor);
			bitmapText.draw(lineSprite);
		}
		
	}

}