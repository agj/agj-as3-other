package cl.agj.ui {
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author agj
	 */
	public class Checkbox extends Button {
		
		protected var _text:String;
		protected var _ticked:Boolean;
		protected var _tickbox:Shape;
		protected var _tickmark:Shape;
		
		public function Checkbox(textString:String, idString:String, widthValue:Number = 200, heightValue:Number = 50) {
			if (heightValue < 14) heightValue = 14;
			super(textString, idString, widthValue, heightValue);
			text = textString;
			
			_textField.x = heightValue;
			_textField.width = widthValue - heightValue;
			
			_tickbox = new Shape;
			with (_tickbox.graphics) {
				beginFill(0xffffff);
				drawRect(2, 2, heightValue - 4, heightValue - 4);
				drawRect(4, 4, heightValue - 8, heightValue - 8);
				endFill();
			}
			addChild(_tickbox);
			_tickmark = new Shape;
			with (_tickmark.graphics) {
				beginFill(0xffffff);
				drawRect(6, 6, heightValue - 12, heightValue - 12);
				endFill();
			}
			addChild(_tickmark);
			
			_tick(false);
			
			addEventListener(MouseEvent.CLICK, _clickHandler, false, 0, true);
		}
		
		public override function set text(textString:String):void {
			_text = textString;
		}
		public override  function get text():String {
			return _text;
		}
		
		public override function set width(widthValue:Number):void {
			_box.width = widthValue;
			_textField.width = widthValue - _tickbox.width + 4;
		}
		
		protected override function _reformat():void {
			super._reformat();
			
			var buttonFormat:ButtonFormat, secondaryFormat:ButtonFormat;
			if (!_mouseOver) buttonFormat = _upStateFormat;
			else {
				buttonFormat = _overStateFormat;
				secondaryFormat = _upStateFormat;
			}
			
			var colorTransform:ColorTransform = new ColorTransform;
			if (buttonFormat.textColor) colorTransform.color = buttonFormat.textColor;
			else if (secondaryFormat) if (secondaryFormat.textColor) colorTransform.color = secondaryFormat.textColor;
			
			_tickbox.transform.colorTransform = colorTransform;
			_tickmark.transform.colorTransform = colorTransform;
		}
		
		public function set ticked(value:Boolean):void {
			_tick(value);
		}
		public function get ticked():Boolean {
			return _ticked;
		}
		
	/*	private function _resetText():void {
			//var tick:String = (_ticked) ? "+" : " ";
			var tick:String = "+";
			_textField.text = "[ " + tick + " ]  " + _text;
			if (!_ticked) {
				var invisible:TextFormat = new TextFormat;
				invisible.color = 0x00ff0000;
				_textField.setTextFormat(invisible, 1, 3);
			}
		} */
		
		private function _clickHandler(e:MouseEvent):void {
			_tick(!_ticked);
		}
		
		private function _tick(status:Boolean):void {
			_ticked = status;
			_tickmark.visible = status;
		}
		
	}
	
}