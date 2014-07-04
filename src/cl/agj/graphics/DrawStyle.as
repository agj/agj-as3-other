package cl.agj.graphics {
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.filters.BitmapFilter;
	
	public class DrawStyle {
		
		private var _fillColor:uint;
		private var _fillAlpha:Number;
		
		private var _lineColor:uint;
		private var _lineAlpha:Number;
		private var _lineWeight:Number;
		
		private var _fillGradient:GradientStyle;
		private var _lineGradient:GradientStyle;
		
		private var _lineCapsStyle:String;
		private var _lineJointStyle:String;
		private var _lineScaleMode:String;
		private var _lineMiterLimit:Number;
		public var linePixelHinting:Boolean;
		
		private var _blendMode:String;
		private var _bitmapFilters:Vector.<BitmapFilter>;
		
		public function DrawStyle(
			fillColor:Object = null,
			fillAlpha:Number = NaN,
			lineColor:Object = null,
			lineWeight:Number = NaN,
			lineAlpha:Number = NaN
			) {
			
			this.fillColor = uint(fillColor);
			this.fillAlpha = fillAlpha;
			
			this.lineColor = uint(lineColor);
			this.lineWeight = lineWeight;
			this.lineAlpha = lineAlpha;
			
			lineCapsStyle = undefined;
			lineJointStyle = undefined;
			lineScaleMode = undefined;
			lineMiterLimit = NaN;
			linePixelHinting = undefined;
			
			blendMode = undefined;
			bitmapFilters = null;
		}
		
		//////
		
		public function set fillColor(value:uint):void {
			_fillColor = checkColor(value);
		}
		public function get fillColor():uint {
			return _fillColor;
		}
		
		public function set fillAlpha(value:Number):void {
			_fillAlpha = checkFraction(value, 1);
		}
		public function get fillAlpha():Number {
			return _fillAlpha;
		}
		
		public function set lineColor(value:uint):void {
			_lineColor = checkColor(value);
		}
		public function get lineColor():uint {
			return _lineColor;
		}
		
		public function set lineAlpha(value:Number):void {
			_lineAlpha = checkFraction(value, 1);
		}
		public function get lineAlpha():Number {
			return _lineAlpha;
		}
		
		public function set lineWeight(value:Number):void {
			if (!isNaN(value))
				_lineWeight = Math.max(0, value);
			else
				_lineWeight = 0;
		}
		public function get lineWeight():Number {
			return _lineWeight;
		}
		
		/////
		
		public function set fillGradient(value:GradientStyle):void {
			_fillGradient = value;
		}
		public function get fillGradient():GradientStyle {
			return _fillGradient;
		}
		
		public function set lineGradient(value:GradientStyle):void {
			_lineGradient = value;
		}
		public function get lineGradient():GradientStyle {
			return _lineGradient;
		}
		
		/////
		
		public function set lineCapsStyle(value:String):void {
			if (value == CapsStyle.NONE || value == CapsStyle.ROUND || value == CapsStyle.SQUARE)
				_lineCapsStyle = value;
			else
				_lineCapsStyle = CapsStyle.NONE;
		}
		public function get lineCapsStyle():String {
			return _lineCapsStyle;
		}
		
		public function set lineJointStyle(value:String):void {
			if (value == JointStyle.BEVEL || value == JointStyle.MITER || value == JointStyle.ROUND)
				_lineJointStyle = value;
			else
				_lineJointStyle = JointStyle.MITER;
		}
		public function get lineJointStyle():String {
			return _lineJointStyle;
		}
		
		public function set lineScaleMode(value:String):void {
			if (value == LineScaleMode.NONE || value == LineScaleMode.NORMAL || value == LineScaleMode.HORIZONTAL || value == LineScaleMode.VERTICAL)
				_lineScaleMode = value;
			else
				_lineScaleMode = LineScaleMode.NORMAL;
		}
		public function get lineScaleMode():String {
			return _lineScaleMode;
		}
		
		public function set lineMiterLimit(value:Number):void {
			if (!isNaN(value))
				_lineMiterLimit = Math.max(0, value);
			else
				_lineMiterLimit = 3;
		}
		public function get lineMiterLimit():Number {
			return _lineMiterLimit;
		}
		
		protected const BLEND_MODES:Array = [BlendMode.ADD, BlendMode.ALPHA, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SHADER, BlendMode.SUBTRACT];
		public function set blendMode(value:String):void {
			if (BLEND_MODES.indexOf(value) >= 0)
				_blendMode = value;
			else
				_blendMode = BlendMode.NORMAL;
		}
		public function get blendMode():String {
			return _blendMode;
		}
		
		public function set bitmapFilters(value:Vector.<BitmapFilter>):void {
			_bitmapFilters = value;
		}
		public function get bitmapFilters():Vector.<BitmapFilter> {
			return _bitmapFilters;
		}
		
		public function toString():String {
			return "[DrawStyle fillColor: " + _fillColor + ", fillAlpha: " + _fillAlpha + ", lineColor: " + _lineColor + ", lineAlpha: " + _lineAlpha + "]";
		}
		
		//////
		
		public function setFill(fillColor:Object = null, fillAlpha:Number = NaN):DrawStyle {
			if (fillColor is uint)
				this.fillColor = fillColor as uint;
			if (!isNaN(fillAlpha))
				this.fillAlpha = fillAlpha;
			return this;
		}
		
		public function setLine(
			lineColor:Object = null,
			lineWeight:Number = NaN,
			lineAlpha:Number = NaN,
			lineCapsStyle:String = undefined,
			lineJointStyle:String = undefined,
			lineScaleMode:String = undefined,
			lineMiterLimit:Number = NaN,
			linePixelHinting:Object = null
			):DrawStyle {
			
			if (lineColor is uint)
				this.lineColor = lineColor as uint;
			if (!isNaN(lineWeight))
				this.lineWeight = lineWeight;
			if (!isNaN(lineAlpha))
				this.lineAlpha = lineAlpha;
			if (lineCapsStyle)
				this.lineCapsStyle = lineCapsStyle;
			if (lineJointStyle)
				this.lineJointStyle = lineJointStyle;
			if (lineScaleMode)
				this.lineScaleMode = lineScaleMode;
			if (!isNaN(lineMiterLimit))
				this.lineMiterLimit = lineMiterLimit;
			if (linePixelHinting is Boolean)
				this.linePixelHinting = linePixelHinting;
			
			return this;
		}
		
		public function setLineCapsStyle(style:String):DrawStyle {
			lineCapsStyle = style;
			return this;
		}
		
		public function setLineJointStyle(style:String):DrawStyle {
			lineJointStyle = style;
			return this;
		}
		
		public function setLineScaleMode(mode:String):DrawStyle {
			lineScaleMode = mode;
			return this;
		}
		
		public function setLineMiterLimit(limit:Number):DrawStyle {
			lineMiterLimit = limit;
			return this;
		}
		
		public function setLinePixelHinting(active:Boolean):DrawStyle {
			linePixelHinting = active;
			return this;
		}
		
		public function setBlendMode(mode:String):DrawStyle {
			blendMode = mode;
			return this;
		}
		
		public function addBitmapFilters(... filters):DrawStyle {
			for each (var f:Object in filters) {
				if (f is BitmapFilter) {
					if (!_bitmapFilters)
						_bitmapFilters = new Vector.<BitmapFilter>;
					_bitmapFilters.push(f as BitmapFilter);
				}
			}
			return this;
		}
		
		public function removeBitmapFilters(... classes):DrawStyle {
			var i:int, f:BitmapFilter;
			for each (var c:Object in classes) {
				if (c is Class) {
					for (i = 0; i < _bitmapFilters.length; i--) {
						f = _bitmapFilters[i];
						if (f is (c as Class))
							_bitmapFilters.splice(i, 1);
					}
				}
			}
			return this;
		}
		
		public function setGradient(fillGradient:GradientStyle = null, lineGradient:GradientStyle = null):DrawStyle {
			this.fillGradient = fillGradient;
			this.lineGradient = lineGradient;
			return this;
		}
		
		//////
		
		public static function makeLineStyle(
				lineColor:Object = null,
				lineWeight:Number = NaN,
				lineAlpha:Number = NaN,
				lineCapsStyle:String = undefined,
				lineJointStyle:String = undefined,
				lineScaleMode:String = undefined,
				lineMiterLimit:Number = NaN,
				linePixelHinting:Boolean = false
			):DrawStyle {
			
			var ds:DrawStyle = new DrawStyle(
				null, 0,
				lineColor,
				lineWeight,
				lineAlpha
			);
			
			ds.lineCapsStyle = lineCapsStyle;
			ds.lineJointStyle = lineJointStyle;
			ds.lineScaleMode = lineScaleMode;
			ds.lineMiterLimit = lineMiterLimit;
			ds.linePixelHinting = linePixelHinting;
			
			return ds;
		}
		
		public static function makeGradientStyle(
				fillGradient:GradientStyle = null,
				lineGradient:GradientStyle = null
			):DrawStyle {
			
			var ds:DrawStyle = new DrawStyle();
			
			ds.fillGradient = fillGradient;
			ds.lineGradient = lineGradient;
			
			return ds;
		}
		
		//////
		
		public function clone():DrawStyle {
			var ds:DrawStyle = new DrawStyle(
				_fillColor,
				_fillAlpha,
				_lineColor,
				_lineWeight,
				_lineAlpha
			);
			
			ds.lineCapsStyle = _lineCapsStyle;
			ds.lineJointStyle = _lineJointStyle;
			ds.lineScaleMode = _lineScaleMode;
			ds.lineMiterLimit = _lineMiterLimit;
			ds.linePixelHinting = linePixelHinting;
			ds.blendMode = blendMode;
			ds.bitmapFilters = bitmapFilters;
			
			return ds;
		}
		
		public function get definesFill():Boolean {
			return (fillAlpha > 0);
		}
		
		public function get definesLine():Boolean {
			return (lineAlpha > 0 && lineWeight > 0);
		}
		
		public function get definesGradientFill():Boolean {
			return (fillGradient != null);
		}
		
		public function get definesGradientLine():Boolean {
			return (lineGradient != null);
		}
		
		public function get definesBlendMode():Boolean {
			return (_blendMode !== BlendMode.NORMAL);
		}
		
		public function get definesBitmapFilters():Boolean {
			return (_bitmapFilters && _bitmapFilters.length > 0);
		}
		
		//////
		
		private function checkColor(value:uint):uint {
			return value & 0xffffff;
		}
		
		private function checkFraction(num:Number, defaultValue:Number):Number {
			if (isNaN(num))
				return defaultValue;
			return Math.max(0, Math.min(1, num));
		}
		
	}
}