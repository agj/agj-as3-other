package cl.agj.graphics {
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	public class GradientStyle {
		
		private var _type:String;
		private var _colors:Array;
		private var _alphas:Array;
		private var _ratios:Array;
		private var _matrix:Matrix;
		private var _spreadMethod:String;
		private var _interpolationMethod:String;
		private var _focalPointRatio:Number;
		
		public function GradientStyle(
				type:String = undefined,
				colors:Array = null,
				alphas:Array = null,
				ratios:Array = null,
				matrix:Matrix = null,
				spreadMethod:String = undefined,
				interpolationMethod:String = undefined,
				focalPointRatio:Number = NaN
			) {
			
			this.type = type;
			this.colors = colors;
			this.alphas = alphas;
			this.ratios = ratios;
			this.matrix = matrix;
			this.spreadMethod = spreadMethod;
			this.interpolationMethod = interpolationMethod;
			this.focalPointRatio = focalPointRatio;
		}
		
		/////
		
		protected const TYPES:Array = [GradientType.LINEAR, GradientType.RADIAL];
		public function set type(value:String):void {
			if (TYPES.indexOf(value) >= 0)
				_type = value;
			else
				_type = GradientType.LINEAR;
		}
		public function get type():String {
			return _type;
		}
		
		public function set colors(value:Array):void {
			_colors = value;
		}
		public function get colors():Array {
			return _colors;
		}
		
		public function set alphas(value:Array):void {
			_alphas = value;
		}
		public function get alphas():Array {
			if (_alphas)
				return _alphas;
			if (!_colors)
				return null;
			
			var len:uint = _colors.length;
			var r:Array = new Array(len);
			var i:int = len;
			while (--i) {
				r[i] = 1;
			}
			return r;
		}
		
		public function set ratios(value:Array):void {
			_ratios = value;
		}
		public function get ratios():Array {
			if (_ratios)
				return _ratios;
			if (!_colors)
				return null;
			
			var len:uint = _colors.length;
			var r:Array = new Array(len);
			var fraction:Number = 255 / (len - 1);
			var i:int = len;
			while (--i) {
				r[i] = Math.round(fraction * i);
			}
			return r;
		}
		
		public function set matrix(value:Matrix):void {
			_matrix = value;
		}
		public function get matrix():Matrix {
			return _matrix;
		}
		
		protected const SPREAD_METHODS:Array = [SpreadMethod.PAD, SpreadMethod.REFLECT, SpreadMethod.REPEAT];
		public function set spreadMethod(value:String):void {
			if (SPREAD_METHODS.indexOf(value) >= 0)
				_spreadMethod = value;
			else
				_spreadMethod = SpreadMethod.PAD;
		}
		public function get spreadMethod():String {
			return _spreadMethod;
		}
		
		protected const INTERPOLATION_METHODS:Array = [InterpolationMethod.LINEAR_RGB, InterpolationMethod.RGB];
		public function set interpolationMethod(value:String):void {
			if (INTERPOLATION_METHODS.indexOf(value) >= 0)
				_interpolationMethod = value;
			else
				_interpolationMethod = InterpolationMethod.RGB;
		}
		public function get interpolationMethod():String {
			return _interpolationMethod;
		}
		
		public function set focalPointRatio(value:Number):void {
			if (isNaN(value))
				_focalPointRatio = 0;
			else
				_focalPointRatio = Math.max(-1, Math.min(1, value));
		}
		public function get focalPointRatio():Number {
			return _focalPointRatio;
		}
		
		/////
		
		public function setType(type:String):GradientStyle {
			this.type = type;
			return this;
		}
		
		public function setColors(colors:Array):GradientStyle {
			this.colors = colors;
			return this;
		}
		
		public function setAlphas(alphas:Array):GradientStyle {
			this.alphas = alphas;
			return this;
		}
		
		public function setRatios(ratios:Array):GradientStyle {
			this.ratios = ratios;
			return this;
		}
		
		public function setMatrix(matrix:Matrix):GradientStyle {
			this.matrix = matrix;
			return this;
		}
		
		public function setSpreadMethod(method:String):GradientStyle {
			this.spreadMethod = method;
			return this;
		}
		
		public function setInterpolationMethod(method:String):GradientStyle {
			this.interpolationMethod = method;
			return this;
		}
		
		public function setFocalPointRatio(focalPointRatio:Number):GradientStyle {
			this.focalPointRatio = focalPointRatio;
			return this;
		}
		
	}
}