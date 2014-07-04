package cl.agj.graphics
{
	import cl.agj.core.utils.MathAgj;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Offers static methods that simplify vector drawing via Graphics objects.
	 * 
	 * @author agj
	 */
	public class Draw {
		
		static public function rectangle(graphics:Graphics, drawStyle:DrawStyle, dimensions:Rectangle):void {
			setFill(graphics, drawStyle);
			setLine(graphics, drawStyle);
			graphics.drawRect(dimensions.x, dimensions.y, dimensions.width, dimensions.height);
			endFillAndLine(graphics, drawStyle);
		}
		
		static public function circle(graphics:Graphics, drawStyle:DrawStyle, diameter:Number, centerX:Number = 0, centerY:Number = 0, diameterAsRadius:Boolean = false):void {
			setFill(graphics, drawStyle);
			setLine(graphics, drawStyle);
			graphics.drawCircle(centerX, centerY, (diameterAsRadius) ? diameter : diameter * 0.5);
			endFillAndLine(graphics, drawStyle);
		}
		
		static public function ring(graphics:Graphics, drawStyle:DrawStyle, outerRadius:int, innerRadius:int, outerCenterX:int = 0, outerCenterY:int = 0, innerCenterX:int = 0, innerCenterY:int = 0):void {
			setFill(graphics, drawStyle);
			setLine(graphics, drawStyle);
			graphics.drawCircle(outerCenterX, outerCenterY, outerRadius);
			graphics.drawCircle(innerCenterX, innerCenterY, innerRadius);
			endFillAndLine(graphics, drawStyle);
		}
		
		static public function line(graphics:Graphics, drawStyle:DrawStyle, toX:Number, toY:Number, fromX:Number = 0, fromY:Number = 0):void {
			if (!drawStyle.definesLine)
				return;
			
			setLine(graphics, drawStyle);
			graphics.moveTo(fromX, fromY);
			graphics.lineTo(toX, toY);
			endFillAndLine(graphics, drawStyle);
		}
		
		static public function polyLine(graphics:Graphics, drawStyle:DrawStyle, positions:Vector.<Point>, close:Boolean = false):void {
			if (!positions || positions.length < 2)
				return;
			
			setFill(graphics, drawStyle);
			setLine(graphics, drawStyle);
			
			graphics.moveTo(positions[0].x, positions[0].y);
			var len:uint = positions.length;
			for (var i:uint = 1; i < len; i++) {
				graphics.lineTo(positions[i].x, positions[i].y);
			}
			if (close)
				graphics.lineTo(positions[0].x, positions[0].y)
			
			endFillAndLine(graphics, drawStyle);
		}
		
		static public function regularPolygon(graphics:Graphics, drawStyle:DrawStyle, sides:uint, vertexRadius:Number, rotation:Number = 0, centerX:Number = 0, centerY:Number = 0):void {
			rotation -= 90;
			var degreeIncrement:Number = 360 / sides;
			
			setFill(graphics, drawStyle);
			setLine(graphics, drawStyle);
			
			var position:Point;
			var currentAngle:Number;
			
			for (var i:int = 0; i <= sides; i++) {
				currentAngle = degreeIncrement * i;
				position = Point.polar(vertexRadius, MathAgj.degToRad(currentAngle + rotation));
				position.x += centerX;
				position.y += centerY;
				if (i == 0)
					graphics.moveTo(position.x, position.y);
				else
					graphics.lineTo(position.x, position.y);
			}
			
			endFillAndLine(graphics, drawStyle);
		}
		
		/////
		
		static private function setFill(g:Graphics, ds:DrawStyle):void {
			if (ds.definesGradientFill) {
				var gs:GradientStyle = ds.fillGradient;
				g.beginGradientFill(gs.type, gs.colors, gs.alphas, gs.ratios, gs.matrix, gs.spreadMethod, gs.interpolationMethod, gs.focalPointRatio);
			} else if (ds.definesFill)
				g.beginFill(ds.fillColor, ds.fillAlpha);
		}
		
		static private function setLine(g:Graphics, ds:DrawStyle):void {
			if (ds.definesGradientLine) {
				var gs:GradientStyle = ds.lineGradient;
				g.lineGradientStyle(gs.type, gs.colors, gs.alphas, gs.ratios, gs.matrix, gs.spreadMethod, gs.interpolationMethod, gs.focalPointRatio);
			} else if (ds.definesLine)
				g.lineStyle(ds.lineWeight, ds.lineColor, ds.lineAlpha, ds.linePixelHinting, ds.lineScaleMode, ds.lineCapsStyle, ds.lineJointStyle, ds.lineMiterLimit);
		}
		
		static private function endFillAndLine(graphics:Graphics, drawStyle:DrawStyle):void {
			if (drawStyle.definesFill || drawStyle.definesGradientFill)
				graphics.endFill();
			if (drawStyle.definesLine || drawStyle.definesGradientLine)
				graphics.lineStyle();
		}
		
	}
	
}