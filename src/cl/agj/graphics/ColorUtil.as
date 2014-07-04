package cl.agj.graphics {
	import cl.agj.core.utils.MathAgj;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	//import mx.utils.HSBColor;
	
	/**
	 * ...
	 * @author agj
	 */
	public class ColorUtil 
	{
		// Stolen from http://www.yafla.com/yaflaColor/ColorRGBHSL.aspx
		public static function splitHSL(color:uint):Object {
			var c:Object = splitARGB(color);
			
			var _hue:Number = 0;
			
			var minVal:uint = Math.min(c.r, c.g, c.b);
			var maxVal:uint = Math.max(c.r, c.g, c.b);
			
			var lightness:Number = maxVal / 255;
			var saturation:Number = 0;
			
			if (maxVal > 0) {
				saturation = ( (maxVal - minVal) / maxVal);
			} else {
				saturation = 0;
			}
			
			var _r:Number, _g:Number, _b:Number;
			
			_r = c.r;
			_g = c.g;
			_b = c.b;
			
			if (minVal > 0) {
				_r = (_r / minVal) - 1;
				_g = (_g / minVal) - 1;
				_b = (_b / minVal) - 1;
			}
			
			var _maxVal:Number;
			_maxVal = Math.max(_r, _g, _b);
			
			if ((_r == _g) && (_g == _b)) {
				// it's a grey - there is no hue
				_hue = 0;
			} else {
				if (_maxVal > 0) {
					_r = _r / _maxVal;
					_g = _g / _maxVal;
					_b = _b / _maxVal;
				}
				
				_maxVal = Math.max(_r, _g, _b);
				
				if (_maxVal == _r) {
					// between -60 and 60 degrees
					if (_g > 0) {
						_hue = 60 * (_g / _r);
					} else {
						_hue = 360 + (-60 * (_b / _r));
					}
				} else if (_maxVal == _g) {
					if (_r > 0) {
						// it's beween 60 and 120
						_hue = 120 - ((_r / _g) * 60);
					} else {
						// it's between 120 and 180
						_hue = 120 + ((_b / _g) * 60);
					}
				} else if (_maxVal == _b) {
					if (_g > 0) {
						// it's between 180 and 240
						_hue = 240 - ((_g / _b) * 60);
					} else {
						// it's between 240 and 300
						_hue = 240 + ((_r / _b) * 60);
					}
				}
			}
			
			// normalize hue
			while (_hue < 0) {
				_hue += 360;
			}
			while (_hue >= 360) {
				_hue -= 360;
			}
			
			// normalize saturation
			if (saturation > 1) {
				saturation = 1;
			}
			if (saturation < 0) { 
				saturation = 0;
			}
			
			// normalize lightness
			if (lightness > 1) {
				lightness = 1;
			}
			if (lightness < 0) { 
				lightness = 0;
			}
			
			return { h: _hue, s: saturation, l: lightness };
		}
		
		public static function HSVtoRGB(hue:Number, sat:Number, val:Number):uint {
			if (val == 0)
				return 0;
			
			hue %= 360;
			if (hue < 0) hue = 360 + hue;
			hue /= 60;
			sat /= 100;
			val /= 100;
			
			var red:Number, green:Number, blue:Number;
			var i:uint, f:Number, p:Number, q:Number, t:Number;
			
			i = Math.floor(hue);
			f = hue - i;
			
			p = val * (1 - sat);
			q = val * (1 - (sat * f));
			t = val * (1 - (sat * (1 - f)));
			
			if (i == 0) {
				red = val;	green = t;		blue = p;
			} else if (i == 1) {
				red = q;	green = val;	blue = p;
			} else if (i == 2) {
				red = p;	green = val;	blue = t;
			} else if (i == 3) {
				red = p;	green = q;		blue = val;
			} else if (i == 4) {
				red = t;	green = p;		blue = val;
			} else if (i == 5) {
				red = val;	green = p;		blue = q;
			}
			red = Math.floor(red * 255);
			green = Math.floor(green * 255);
			blue = Math.floor(blue * 255);
			
			return uint((red * 256 * 256) + (green * 256) + blue);
		}
		
		/**
		 * @returns		An Object with channel values split: { a:uint, r:uint, g:uint, b:uint }
		 */
		public static function splitARGB(color:uint):Object {
			var result:Object = {};
			
			result.a = color >> 24 & 0xff;
			result.r = color >> 16 & 0xff;
			result.g = color >> 8 & 0xff;
			result.b = color & 0xff;
			
			return result;
		}
		
		public static function randomizeColor(color:uint, randAmount:uint = 0xff * 3):uint {
			var splitColor:Object = splitARGB(color);
			
			var currRandom:int = MathAgj.random(randAmount + 1);
			var newRandAmount:uint = randAmount - currRandom;
			currRandom -= Math.round(randAmount / 2)
			randAmount = newRandAmount;
			
			splitColor.r = Math.min(Math.max(splitColor.r + currRandom, 0), 0xff);
			
			currRandom = MathAgj.random(randAmount + 1);
			newRandAmount = randAmount - currRandom;
			currRandom -= Math.round(randAmount / 2);
			randAmount = newRandAmount;
			
			splitColor.g = Math.min(Math.max(splitColor.g + currRandom, 0), 0xff);
			
			var sign:Number = (MathAgj.random(2) == 1) ? +1 : -1 ;
			currRandom = randAmount * sign;
			
			splitColor.b = Math.min(Math.max(splitColor.b + currRandom, 0), 0xff);
			
			//return uint("0x" + splitColor[1].toString(16) + splitColor[2].toString(16) + splitColor[3].toString(16));
			return rgbToColor(splitColor.r, splitColor.g, splitColor.b);
		}
		
		/**
		 * Randomizes an RGB color in different HSB parameters.
		 * @param	rgbColor
		 * @param	hueRandAmount			Maximum of 360.
		 * @param	saturationRandAmount	Maximum of 1.
		 * @param	brightnessRandAmount	Maximum of 1.
		 * @return							The randomized color in RGB format.
		 */
		/*public static function randomizeHSB(rgbColor:uint, hueRandAmount:Number = 0, saturationRandAmount:Number = 0, brightnessRandAmount:Number = 0):uint {
			var hsbColor:HSBColor = HSBColor.convertRGBtoHSB(rgbColor);
			
			if (!isNaN(hsbColor.hue)) {
				hueRandAmount = Math.min(Math.max(hueRandAmount, 0), 360);
				var randomHue:Number = hsbColor.hue + (Math.random() * hueRandAmount) - (hueRandAmount / 2);
				if (randomHue >= 360) randomHue -= 360;
				else if (randomHue < 0) randomHue += 360;
				hsbColor.hue = randomHue;
			}
			
			saturationRandAmount = Math.min(Math.max(saturationRandAmount, 0), 1);
			var randomSaturation:Number = Math.min(Math.max(hsbColor.saturation + (Math.random() * saturationRandAmount) - (saturationRandAmount / 2), 0), 1);
			hsbColor.saturation = randomSaturation;
			
			brightnessRandAmount = Math.min(Math.max(brightnessRandAmount, 0), 1);
			var randomBrightness:Number = Math.min(Math.max(hsbColor.brightness + (Math.random() * brightnessRandAmount) - (brightnessRandAmount / 2), 0), 1);
			hsbColor.brightness = randomBrightness;
			
			return HSBColor.convertHSBtoRGB(hsbColor.hue, hsbColor.saturation, hsbColor.brightness);
		}*/
		
		public static function rgbToColor(r:uint, g:uint, b:uint, a:uint = 0):uint {
			return (a << 24 | r << 16 | g << 8 | b);
			//return r * 0x10000 + g * 0x100 + b;
		}
		
		public static function colorToHexRGB(color:uint):String {
			var colorString:String = color.toString(16);
			while (colorString.length < 6) colorString = "0" + colorString;
			return colorString;
		}
		public static function colorToHexARGB(color:uint):String {
			var colorString:String = color.toString(16);
			while (colorString.length < 8) colorString = "0" + colorString;
			return colorString;
		}
		
		public static function interpolateColor(fraction:Number, startValue:uint, endValue:uint):uint {
			fraction = Math.max(0, Math.min(1, fraction));
			
			var startARGB:Object = splitARGB(startValue);
			var endARGB:Object = splitARGB(endValue);
			var result:uint;
			
			result = int(MathAgj.interpolate(fraction, startARGB.r, endARGB.r)) * 0x10000;
			result += int(MathAgj.interpolate(fraction, startARGB.g, endARGB.g)) * 0x100;
			result += int(MathAgj.interpolate(fraction, startARGB.b, endARGB.b));
			
			return result;
		}
		
		public static function tint(object:DisplayObject, color:uint):void {
			var ct:ColorTransform = new ColorTransform;
			ct.color = color;
			object.transform.colorTransform = ct;
		}
		
		public static function percentTintCT(color:uint, tintAmount:Number):ColorTransform {
			var ct:ColorTransform = new ColorTransform;
			ct.color = color;
			//trace(ct.redOffset, ct.greenOffset, ct.blueOffset, ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier);
			ct.redOffset *= tintAmount;
			ct.greenOffset *= tintAmount;
			ct.blueOffset *= tintAmount;
			ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = 1 - tintAmount;
			return ct;
		}
		
		/**
		 * Takes a monochrome image and turns it into a two-color image.
		 */
		public static function makeDuotone(img:Bitmap, lightColor:uint, darkColor:uint):Bitmap {
			var bd:BitmapData = img.bitmapData;
			for (var x:int = bd.width - 1; x >= 0; x--) {
				for (var y:int = bd.height - 1; y >= 0; y--) {
					if (bd.getPixel(x, y) === 0x000000)
						bd.setPixel(x, y, darkColor);
					else if (bd.getPixel(x, y) === 0xffffff)
						bd.setPixel(x, y, lightColor);
				}
			}
			return img;
		}
		
	}
	
}