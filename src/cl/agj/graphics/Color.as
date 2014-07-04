package cl.agj.graphics {
	import flash.geom.ColorTransform;
	
	/**
	 * A class that simplifies manipulating colors by their RGB and HSV values.
	 * HSV to/from RGB conversion code adapted from sekati.utils.ColorUtil.
	 * 
	 * @author agj
	 */
	
	public class Color {
		
		public static const HUE_MAX : uint = 360;
		public static const SATURATION_MAX : uint = 1;
		public static const VALUE_MAX : uint = 255;
		
		protected var _red:uint;
		protected var _green:uint;
		protected var _blue:uint;
		protected var _hue:uint;
		protected var _saturation:Number;
		protected var _value:Number;
		
		protected var _hsvDirty:Boolean;
		protected var _rgbDirty:Boolean;
		
		public function Color(color:uint = 0) {
			hex = color;
		}
		
		public function get red():int {
			makeRGB();
			return _red;
		}
		public function get green():int {
			makeRGB();
			return _green;
		}
		public function get blue():int {
			makeRGB();
			return _blue;
		}
		
		public function get hue():Number {
			makeHSV();
			return _hue;
		}
		public function get saturation():Number {
			makeHSV();
			return _saturation;
		}
		public function get value():Number {
			makeHSV();
			return _value;
		}
		
		public function get hex():uint {
			makeRGB();
			return (_red << 16 | _green << 8 | _blue);
		}
		public function set hex(value:uint):void {
			_red = value >> 16 & 0xff;
			_green = value >> 8 & 0xff;
			_blue = value & 0xff;
			rgbChanged();
		}
		
		public function getHex32(alpha:uint):uint {
			makeRGB();
			return ((alpha & 0xff) << 24 | _red << 16 | _green << 8 | _blue);
		}
		
		public function set red(value:int):void {
			makeRGB();
			_red = adjustHexValue(value);
			rgbChanged();
		}
		public function set green(value:int):void {
			makeRGB();
			_green = adjustHexValue(value);
			rgbChanged();
		}
		public function set blue(value:int):void {
			makeRGB();
			_blue = adjustHexValue(value);
			rgbChanged();
		}
		
		public function set hue(value:Number):void {
			makeHSV();
			_hue = value;
			hsvChanged();
		}
		public function set saturation(value:Number):void {
			makeHSV();
			_saturation = Math.max(value, 0);
			hsvChanged();
		}
		public function set value(value:Number):void {
			makeHSV();
			_value = Math.max(value, 0);
			hsvChanged();
		}
		
		/////
		
		public function clone(hueOffset:Number = 0, saturationOffset:Number = 0, valueOffset:Number = 0):Color {
			var c:Color = new Color(hex);
			if (hueOffset != 0 && !isNaN(hueOffset))
				c.hue += hueOffset;
			if (saturationOffset != 0 && !isNaN(saturationOffset))
				c.saturation += saturationOffset;
			if (valueOffset != 0 && !isNaN(valueOffset))
				c.value += valueOffset;
			return c;
		}
		
		public function transform(colorTransform:ColorTransform):Color {
			red   = red * colorTransform.redMultiplier + colorTransform.redOffset;
			green = green * colorTransform.greenMultiplier + colorTransform.greenOffset;
			blue  = blue * colorTransform.blueMultiplier + colorTransform.blueOffset;
			return this;
		}
		
		/////
		
		protected function rgbChanged():void {
			_rgbDirty = false;
			_hsvDirty = true;
		}
		protected function hsvChanged():void {
			_hsvDirty = false;
			_rgbDirty = true;
		}
		
		protected function makeHSV():void {
			if (!_hsvDirty)
				return;
			
			var hsv:Object = rgbToHSV(_red, _green, _blue);
			_hue = hsv.h;
			_saturation = hsv.s;
			_value = hsv.v;
			
			_hsvDirty = false;
		}
		protected function makeRGB():void {
			if (!_rgbDirty)
				return;
			
			var rgb:Object = hsvToRGB(_hue, _saturation, _value);
			_red = rgb.r;
			_green = rgb.g;
			_blue = rgb.b;
			
			_rgbDirty = false;
		}
		
		protected function adjustHexValue(value:int):int {
			return Math.min(0xff, Math.max(0, value));
		}
		
		/////
		
		public static function rgbToHSV(red:Number, green:Number, blue:Number):Object {
			var min:Number, max:Number, s:Number, v:Number, h:Number = 0;
			
			max = Math.max( red, Math.max( green, blue ) );
			min = Math.min( red, Math.min( green, blue ) );
			
			if (max == 0) {
				return { h: 0, s: 0, v: 0 };
			}
			
			v = max;
			s = (max - min) / max;
			
			h = rgbToHue( red, green, blue );
			
			return { h: h, s: s, v: v };
		}
		
		public static function rgbToHue(red : Number, green : Number, blue : Number) : uint {
			var f : Number, min : Number, mid : Number, max : Number, n : Number;
			
			max = Math.max( red, Math.max( green, blue ) );
			min = Math.min( red, Math.min( green, blue ) );
			
			// achromatic case
			if (max - min == 0) {
				return 0;
			}
			
			mid = middleValue( red, green, blue );
			
			// using this loop to avoid super-ugly nested ifs
			while (true) {
				if (red == max) {
					if (blue == min)
						n = 0;
					else
						n = 5;
					break;
				}
				
				if (green == max) {
					if (blue == min)
						n = 1;
					else
						n = 2;
					break;
				}
				
				if (red == min)
					n = 3;
				else
					n = 4;
				break;
			}
			
			if ((n % 2) == 0) {
				f = mid - min;
			} else {
				f = max - mid;
			}
			f = f / (max - min);
			
			return 60 * (n + f);
		}
		
		public static function middleValue(a:Number, b:Number, c:Number):Number {
			if ((a > b) && (a > c)) {
				if (b > c)      return b; 
				else            return c;
			} else if ((b > a) && (b > c)) {
				if (a > c)      return a;
				else            return c;
			} else if (a > b) {
				return a;
			} else {
				return b;
			}
		}
		
		public static function hsvToRGB(hue:Number, saturation:Number, value:Number):Object {
			var min:Number = (1 - saturation) * value;
			
			return hueToRGB(min, value, hue);
		}
		
		public static function hueToRGB(min:Number, max:Number, hue:Number):Object {
			var mu : Number, md : Number, F : Number, n : Number;
			while (hue < 0) {
				hue += HUE_MAX;
			}
			n = Math.floor( hue / 60 );
			F = (hue - n * 60) / 60;
			n %= 6;
			
			mu = min + ((max - min) * F);
			md = max - ((max - min) * F);
			
			switch (n) {
				case 0: 
					return {r: max, g: mu, b: min};
				case 1: 
					return {r: md, g: max, b: min};
				case 2: 
					return {r: min, g: max, b: mu};
				case 3: 
					return {r: min, g: md, b: max};
				case 4: 
					return {r: mu, g: min, b: max};
				case 5: 
					return {r: max, g: min, b: md};
			}
			return null;
		}
		
		/////
		
		public function toString():String {
			var string:String = hex.toString(16);
			while (string.length < 6)
				string = "0" + string;
			return string;
		}
		
	}
}