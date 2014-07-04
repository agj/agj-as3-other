package cl.agj.extra.text 
{
	import cl.agj.core.display.TidyGraphic;
	
	import flash.text.engine.TextLine;
	
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	/**
	 * ...
	 * @author agj
	 */
	public class Label extends TidyGraphic {
		
		private var _text:String;
		private var _textLine:TextLine;
		private var _format:TextLayoutFormat;
		private var _factory:TextLineFactory;
		
		public function Label(format:TextLayoutFormat, text:String = undefined) {
			_format = format;
			_text = text;
			_factory = new TextLineFactory(_format);
			
			_redrawTextLine();
		}
		
		/////
		
		public function set text(textString:String):void {
			_text = textString;
			_redrawTextLine();
		}
		public function get text():String {
			return _text;
		}
		
		public function set format(newFormat:TextLayoutFormat):void {
			_format = newFormat;
			_redrawTextLine();
		}
		public function get format():TextLayoutFormat {
			return _format;
		}
		
		override public function get width():Number {
			return _textLine.textWidth;
		}
		
		override public function get height():Number {
			return _textLine.textHeight;
		}
		
		public function get ascent():Number {
			return _textLine.ascent;
		}
		
		public function get descent():Number {
			return _textLine.descent;
		}
		
		/////
		
		protected function _redrawTextLine():void {
			if (_textLine) {
				_textLine.parent.removeChild(_textLine);
			}
			
			if (!_text || !_format)
				return;
			
			_factory.textFormat = _format;
			_factory.makeTextLine(_text);
			_textLine = _factory.textLine;
			
			_textLine.x = _textLine.y = 0;
			addChild(_textLine);
			
			if (_format.textAlign) {
				if (_format.textAlign == TextAlign.RIGHT)
					_textLine.x = -_textLine.textWidth;
				else if (_format.textAlign == TextAlign.CENTER)
					_textLine.x = -(_textLine.textWidth * 0.5);
			}
		}
		
	}
	
}