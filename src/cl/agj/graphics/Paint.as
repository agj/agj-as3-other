package cl.agj.graphics {
	import cl.agj.core.utils.ListUtil;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Offers static methods that simplify drawing on BitmapDatas.
	 * 
	 * @author agj
	 */
	public class Paint {
		
		static private var _sprite:Sprite = new Sprite;
		static private var _shape:Shape = new Shape;
		static private var _origin:Point = new Point;
		
		static public function drawLine(bd:BitmapData, drawStyle:DrawStyle, fromX:Number, fromY:Number, toX:Number, toY:Number):void {
			resetShape();
			
			if ((fromX != toX) || (fromY != toY)) {
				// If points are not equal, draw a proper line.
				Draw.line(_shape.graphics, drawStyle, toX, toY, fromX, fromY);
			} else {
				// Otherwise, just a dot.
				if (drawStyle.lineCapsStyle == CapsStyle.ROUND) {
					Draw.circle(_shape.graphics, drawStyle, drawStyle.lineWeight, fromX, fromY);
				} else {
					var halfLT:Number = drawStyle.lineWeight / 2;
					Draw.rectangle(_shape.graphics, drawStyle, new Rectangle(fromX - halfLT, fromY - halfLT, drawStyle.lineWeight, drawStyle.lineWeight));
				}
			}
			
			if (drawStyle.definesBlendMode)
				_shape.blendMode = drawStyle.blendMode;
			if (drawStyle.definesBitmapFilters)
				_shape.filters = ListUtil.toArray(drawStyle.bitmapFilters);
			
			bd.draw(_sprite);
		}
		
		static public function drawPolyLine(bd:BitmapData, drawStyle:DrawStyle, positions:Vector.<Point>):void {
			resetShape();
			
			Draw.polyLine(_shape.graphics, drawStyle, positions);
			
			if (drawStyle.definesBlendMode)
				_shape.blendMode = drawStyle.blendMode;
			if (drawStyle.definesBitmapFilters)
				_shape.filters = ListUtil.toArray(drawStyle.bitmapFilters);
			
			bd.draw(_sprite);
		}
		
		static public function drawCurve(bd:BitmapData, drawStyle:DrawStyle, fromX:Number, fromY:Number, midX:Number, midY:Number, toX:Number, toY:Number):void {
			resetShape();
			
			if ((fromX != toX) || (fromY != toY)) {
				_shape.graphics.lineStyle(drawStyle.lineWeight, drawStyle.lineColor, drawStyle.lineAlpha, drawStyle.linePixelHinting, drawStyle.lineScaleMode, drawStyle.lineCapsStyle, drawStyle.lineJointStyle, drawStyle.lineMiterLimit);
				_shape.graphics.moveTo(fromX, fromY);
				_shape.graphics.curveTo(midX, midY, toX, toY);
			} else {
				if (drawStyle.lineCapsStyle == CapsStyle.ROUND) {
					Draw.circle(_shape.graphics, drawStyle, drawStyle.lineWeight, fromX, fromY);
				} else {
					var halfLT:Number = drawStyle.lineWeight / 2;
					Draw.rectangle(_shape.graphics, drawStyle, new Rectangle(fromX - halfLT, fromY - halfLT, drawStyle.lineWeight, drawStyle.lineWeight));
				}
			}
			
			if (drawStyle.definesBlendMode)
				_shape.blendMode = drawStyle.blendMode;
			if (drawStyle.definesBitmapFilters)
				_shape.filters = ListUtil.toArray(drawStyle.bitmapFilters);
			
			bd.draw(_sprite);
		}
		
		static public function drawCircle(bd:BitmapData, drawStyle:DrawStyle, centerX:Number, centerY:Number, radius:Number):void {
			resetShape();
			
			Draw.circle(_shape.graphics, drawStyle, radius, centerX, centerY, true);
			
			if (drawStyle.definesBlendMode)
				_shape.blendMode = drawStyle.blendMode;
			if (drawStyle.definesBitmapFilters)
				_shape.filters = ListUtil.toArray(drawStyle.bitmapFilters);
			
			bd.draw(_sprite);
		}
		
		/**
		 * @param fillColor		In the format 0xAARRGGBB.
		 */
		static public function fill(bd:BitmapData, fillColor:uint = 0xffffffff, fillAlpha:Number = 1):void {
			var rect:Rectangle = bd.rect;
			if (fillAlpha >= 1) {
				bd.fillRect(rect, fillColor);
			} else {
				fillAlpha = Math.max(fillAlpha, 0);
				var c:Object = ColorUtil.splitARGB(fillColor);
				var r:Number = fillAlpha;
				var ir:Number = 1 - fillAlpha;
				var cmf:ColorMatrixFilter = new ColorMatrixFilter([
					ir, 0, 0, 0, c.r * r,
					0, ir, 0, 0, c.g * r,
					0, 0, ir, 0, c.b * r,
					0, 0, 0, 1, 0
				]);
				
				var _bd:BitmapData = clone(bd);
				_bd.fillRect(rect, 0x00000000);
				_bd.draw(bd);
				bd.applyFilter(_bd, rect, _origin, cmf);
			}
		}
		
		/**
		 * Makes every pixel more transparent. Very small values may cause no effect.
		 * @param	washAlpha	1 is totally transparent; 0 does nothing.
		 */
		static public function wash(bd:BitmapData, washAlpha:Number):void {
			washAlpha = Math.min(Math.max(washAlpha, 0), 1);
			var cmf:ColorMatrixFilter = new ColorMatrixFilter([
				1, 0, 0, 0, 0,
				0, 1, 0, 0, 0,
				0, 0, 1, 0, 0,
				0, 0, 0, 1 - washAlpha, 0
				//0, 0, 0, 1, -washAlpha
			]);
			
			var _bd:BitmapData = clone(bd);
			var rect:Rectangle = bd.rect;
			_bd.fillRect(rect, 0);
			_bd.draw(bd);
			bd.applyFilter(_bd, rect, _origin, cmf);
		}
		
		static public function blur(bd:BitmapData, amountX:Number = 1, amountY:Number = 1):void {
			var _bd:BitmapData = clone(bd);
			var rect:Rectangle = bd.rect;
			_bd.fillRect(rect, 0);
			_bd.draw(bd);
			bd.applyFilter(_bd, rect, _origin, new BlurFilter(amountX, amountY));
		}
		
		/////
		
		static private function clone(_bd:BitmapData):BitmapData {
			return new BitmapData(_bd.width, _bd.height);
		}
		
		static private function resetShape():void {
			_shape.graphics.clear();
			_shape.blendMode = BlendMode.NORMAL;
			_shape.filters = null;
			if (!_shape.parent)
				_sprite.addChild(_shape);
		}
		
	}
}