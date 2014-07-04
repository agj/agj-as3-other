package cl.agj.ui 
{
	import cl.agj.graphics.Draw;
	import cl.agj.graphics.DrawStyle;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	//import flash.text.engine.FontLookup;
	
	/**
	 * ...
	 * @author agj
	 */
	public class Button extends Sprite {
		
		public var id:String;
		
		protected var _box:Shape;
		//private var _label:Label;
		protected var _upStateFormat:ButtonFormat;
		protected var _overStateFormat:ButtonFormat;
		protected var _mouseOver:Boolean;
		protected var _textField:TextField;
		
		public function Button(textString:String, idString:String, widthValue:Number = 200, heightValue:Number = 50) {
			
			id = idString;
			
			_box = new Shape;
			Draw.rectangle(_box.graphics, new DrawStyle(0xffffff, 1), new Rectangle(0, 0, widthValue, heightValue));
			addChild(_box);
			
			_textField = new TextField;
			_textField.width = widthValue;
			_textField.height = heightValue; // - topMarginValue;
			//_textField.y = topMarginValue;
			_textField.selectable = false;
			_textField.embedFonts = true;
			_textField.text = textString;
			addChild(_textField);
			
			addEventListener(MouseEvent.ROLL_OVER, _rollOverHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, _rollOutHandler, false, 0, true);
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
		}
		
		public override function set width(widthValue:Number):void {
			_box.width = widthValue;
			_textField.width = widthValue;
		}
		public override function get width():Number {
			return _box.width;
		}
		
		public override function set height(heightValue:Number):void {
			_box.height = heightValue;
			_textField.height = heightValue;
		}
		public override function get height():Number {
			return _box.height;
		}
		
		public function set text(textString:String):void {
			_textField.text = textString;
		}
		public function get text():String {
			return _textField.text;
		}
		
		public function set upStateFormat(format:ButtonFormat):void {
			_upStateFormat = format;
			if (!_mouseOver) _reformat();
		}
		public function get upStateFormat():ButtonFormat {
			return _upStateFormat;
		}
		
		public function set overStateFormat(format:ButtonFormat):void {
			_overStateFormat = format;
			if (_mouseOver) _reformat();
		}
		public function get overStateFormat():ButtonFormat {
			return _overStateFormat;
		}
		
		protected function _reformat():void {
			var buttonFormat:ButtonFormat, secondaryFormat:ButtonFormat;
			
			if (!_mouseOver) buttonFormat = _upStateFormat;
			else {
				buttonFormat = _overStateFormat;
				secondaryFormat = _upStateFormat;
			}
			
			_setTextFormat();
			
			if (buttonFormat.color is Number) {
				var colorTransform:ColorTransform = new ColorTransform();
				colorTransform.color = buttonFormat.color;
				_box.transform.colorTransform = colorTransform;
			}
			if (buttonFormat.transparent is Boolean) {
				_box.alpha = (buttonFormat.transparent) ? 0 : 1;
			}
			
		}
		
		protected function _setTextFormat():void {
			var buttonFormat:ButtonFormat, secondaryFormat:ButtonFormat;
			
			if (!_mouseOver) buttonFormat = _upStateFormat;
			else {
				buttonFormat = _overStateFormat;
				secondaryFormat = _upStateFormat;
			}
			
			var layoutFormat:TextFormat = new TextFormat;
			
			if (buttonFormat.font) layoutFormat.font = buttonFormat.font;
			else if (secondaryFormat) if (secondaryFormat.font) layoutFormat.font = secondaryFormat.font;
			if (buttonFormat.textSize) layoutFormat.size = buttonFormat.textSize;
			else if (secondaryFormat) if (secondaryFormat.textSize) layoutFormat.size = secondaryFormat.textSize;
			if (buttonFormat.textColor) layoutFormat.color = buttonFormat.textColor;
			else if (secondaryFormat) if (secondaryFormat.textColor) layoutFormat.color = secondaryFormat.textColor;
			
			var alignment:String, margin:Number = 0;
			if (buttonFormat.alignment) alignment = buttonFormat.alignment;
			else if (secondaryFormat) if (secondaryFormat.alignment) alignment = secondaryFormat.alignment;
			if (buttonFormat.margin) margin = buttonFormat.margin;
			else if (secondaryFormat) if (secondaryFormat.margin) margin = secondaryFormat.margin;
			
			if (alignment) {
				if (alignment == ButtonFormat.ALIGN_LEFT) {
					layoutFormat.align = TextFormatAlign.LEFT;
					layoutFormat.leftMargin = margin;
				}
				else if (alignment == ButtonFormat.ALIGN_RIGHT) {
					layoutFormat.align = TextFormatAlign.RIGHT;
					layoutFormat.rightMargin = margin;
				}
				else if (alignment == ButtonFormat.ALIGN_CENTER) {
					layoutFormat.align = TextFormatAlign.CENTER;
				}
			}
			
			_textField.defaultTextFormat = layoutFormat;
			_textField.setTextFormat(layoutFormat);
		}
		
		private function _rollOverHandler(e:MouseEvent):void {
			_mouseOver = true;
			_reformat();
		}
		private function _rollOutHandler(e:MouseEvent):void {
			_mouseOver = false;
			_reformat();
		}

	}
	
}