package cl.agj.graphics.brush {
	import cl.agj.core.Destroyable;
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.utils.ListUtil;
	import cl.agj.core.utils.MathAgj;
	import cl.agj.graphics.DrawStyle;
	import cl.agj.graphics.Paint;
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import cl.agj.graphics.brush.vo.StrokeStatus;
	import cl.agj.graphics.brush.vo.StrokeNode;
	import cl.agj.graphics.brush.vo.Stroke;

	/**
	 * Deprecated. Use StrokeGenerator.
	 * @author agj
	 */
	[Deprecated("Use StrokeGenerator")]
	public class Brush extends Destroyable {
		
		public var canvas:BitmapData;
		public var size:Number = 3;
		public var color:uint = 0x000000;
		/** The higher this number, the smoother the line, but line thickness adjusts less quickly to movement speed. */
		public var smoothingSamples:uint = 3;
		/** A factor of 'size'. */
		public var peakSize:Number = 1.5;
		/** The larger this number is, the lower the size variation. */
		public var sizeVariation:Number = 0.5;
		public var alpha:Number = 1;
		
		protected var _strokes:Vector.<Stroke> = new Vector.<Stroke>;
		protected var _strokeStatuses:Dictionary = new Dictionary;
		
		private var _pt1:Point = new Point;
		private var _pt2:Point = new Point;
		private var _pt3:Point = new Point;
		
		//protected var _time:uint;
		//protected var _timePrev:uint;
		//protected var _record:Vector.<Object> = new Vector.<Object>;
		//protected var _center:Point = new Point;
		//protected var _mousePrev:Point = new Point;
		//protected var _mousePrevPrev:Point = new Point;
		//protected var _speedPrev:Number;
		
		public function Brush(canvas:BitmapData = null) {
			this.canvas = canvas;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		
		public function startStroke(x:Number, y:Number):Stroke {
			if (!canvas)
				return null;
			
			var stroke:Stroke //= new Stroke(new Point(x, y), new <StrokeNode>[new StrokeNode(0, 0, 0)]);
			_strokes.push(stroke);
			
			var status:StrokeStatus = new StrokeStatus;
			status.startTime = status.previousTime = getTimer();
			_strokeStatuses[stroke] = status;
			
			return stroke;
			
			/*
			updateTime();
			
			_center.x = x;
			_center.y = y;
			
			_record.splice(0, _record.length);
			writeToRecord(x, y, 0);
			writeToRecord(x, y, 0);
			
			_mousePrev.x = _mousePrevPrev.x = 0;
			_mousePrev.y = _mousePrevPrev.y = 0;
			
			_pressed = true;
			*/
		}
		
		public function extendStroke(stroke:Stroke, x:Number, y:Number):void {
			if (!canvas || _strokes.indexOf(stroke) < 0) return;
			
			var time:int = getTimer();
			
			var status:StrokeStatus = _strokeStatuses[stroke];
			var nodes:Vector.<StrokeNode> = stroke.nodes;
			nodes.push(new StrokeNode(x - stroke.center.x, y - stroke.center.y, time - status.previousTime));
			status.previousTime = time;
			
			var len:int = nodes.length;
			var speed:Number = avgSpeed(stroke);
			if (len === 2) {
				_pt1.x = _pt2.x = nodes[0].x;
				_pt1.y = _pt2.y = nodes[0].y;
				_pt3.x = nodes[1].x;
				_pt3.y = nodes[1].y;
			} else if (len > 2) {
				_pt1.x = nodes[len - 3].x;
				_pt1.y = nodes[len - 3].y;
				_pt2.x = nodes[len - 2].x;
				_pt2.y = nodes[len - 2].y;
				_pt3.x = nodes[len - 1].x;
				_pt3.y = nodes[len - 1].y;
			} else {
				throw new Error("Insufficient stroke nodes.");
			}
			drawCurve(stroke.center, _pt1, _pt2, _pt3, size, speed);
			
			/*
			updateTime();
			writeToRecord(x, y, _time);
			
			var point:Point = new Point(x - _center.x, y - _center.y);
			var speed:Number = _speedPrev = avgSpeed();
			drawCurve(_center, _mousePrevPrev, _mousePrev, point, size, speed);
			
			_mousePrevPrev = _mousePrev;
			_mousePrev = point;
			*/
		}
		
		public function endStroke(stroke:Stroke):void {
			if (!canvas || _strokes.indexOf(stroke) < 0) return;
			
			var nodes:Vector.<StrokeNode> = stroke.nodes;
			var speed:Number = avgSpeed(stroke);
			var len:int = nodes.length;
			
			_pt1.x = nodes[len - 2].x;
			_pt1.y = nodes[len - 2].y;
			_pt2.x = nodes[len - 1].x;
			_pt2.y = nodes[len - 1].y;
			endLine(stroke.center, _pt1, _pt2, size, speed);
			
			ListUtil.remove(_strokes, stroke);
			delete _strokeStatuses[stroke];
			
			/*
			_pressed = false;
			
			updateTime();
			endLine(_center, _mousePrevPrev, _mousePrev, size, _speedPrev);
			*/
		}
		
		////////////////////////////////////////////////////////////////////////////////
		
		protected function drawCurve(center:Point, pt1:Point, pt2:Point, pt3:Point, size:Number, speed:Number):Point {
			var ptA:Point, ptB:Point;
			
			ptA = Point.interpolate(pt1, pt2, 0.5);
			ptB = Point.interpolate(pt2, pt3, 0.5);
			
			var width:Number;
			var length:Number = pt3.subtract(pt2).length;
			if (speed == 0 || isNaN(speed))
				width = size;
			else
				width = size * MathAgj.curve(speed, sizeVariation, peakSize);
			
			var ds:DrawStyle = DrawStyle.makeLineStyle(color, width, alpha, CapsStyle.ROUND);
			if (Point.distance(ptA,pt2) + Point.distance(pt2,ptB) > 5)
				Paint.drawCurve(canvas, ds, ptA.x + center.x, ptA.y + center.y, pt2.x + center.x, pt2.y + center.y, ptB.x + center.x, ptB.y + center.y);
				//canvas.drawCurve(ds, ptA.x + center.x, ptA.y + center.y, pt2.x + center.x, pt2.y + center.y, ptB.x + center.x, ptB.y + center.y);
				//canvas.drawCurve(ptA.x + center.x, ptA.y + center.y, pt2.x + center.x, pt2.y + center.y, ptB.x + center.x, ptB.y + center.y, color, width, alpha, CapsStyle.ROUND);
			else
				Paint.drawLine(canvas, ds, ptA.x + center.x, ptA.y + center.y, ptB.x + center.x, ptB.y + center.y);
				//canvas.drawLine(ds, ptA.x + center.x, ptA.y + center.y, ptB.x + center.x, ptB.y + center.y);
				//canvas.drawLine(ptA.x + center.x, ptA.y + center.y, ptB.x + center.x, ptB.y + center.y, color, width, alpha, CapsStyle.ROUND);
			
			return pt3;
		}
		
		protected function endLine(center:Point, from:Point, to:Point, size:Number, speed:Number):void {
			from = Point.interpolate(from, to, 0.5);
			
			var width:Number;
			if (speed == 0 || isNaN(speed))
				width = size;
			else
				width = size * MathAgj.curve(speed, sizeVariation, peakSize);
			
			var ds:DrawStyle = DrawStyle.makeLineStyle(color, width, alpha, CapsStyle.ROUND);
			Paint.drawLine(canvas, ds, from.x + center.x, from.y + center.y, to.x + center.x, to.y + center.y);
			//canvas.drawLine(ds, from.x + center.x, from.y + center.y, to.x + center.x, to.y + center.y);
			//canvas.drawLine(from.x + center.x, from.y + center.y, to.x + center.x, to.y + center.y, color, width, alpha, CapsStyle.ROUND);
		}
		
		////////////////////////////////////////////////////////////////////////////////
		
		/*
		protected function updateTime():void {
			_timePrev = _time;
			_time = getTimer();
		}
		
		protected function writeToRecord(x:Number, y:Number, time:uint):void {
			if (_record.length >= smoothingSamples)
				_record.shift();
			_record.push( {
				x: x,
				y: y,
				delay: Math.max(time - _timePrev, 0)
			} );
		}
		*/
		
		protected function avgSpeed(stroke:Stroke):Number {
			var time:uint = 0;
			var distance:Number = 0;
			var nodes:Vector.<StrokeNode> = stroke.nodes;
			
			var index:int = nodes.length - 1;
			for (var i:int = 0; i < smoothingSamples; i++) {
				time += nodes[index].delay;
				if (index > 0) {
					_pt1.x = nodes[index - 1].x;
					_pt1.x = nodes[index - 1].y;
					_pt2.x = nodes[index].x;
					_pt2.x = nodes[index].y;
					distance += Point.distance(_pt1, _pt2);
					index--;
				}
			}
			
			return (distance/smoothingSamples) / (time/smoothingSamples);
			
			/*
			var index:int = _record.length - 1;
			var time:uint = 0;
			var pt1:Point = new Point(), pt2:Point = new Point();
			var distance:Number = 0;
			for (var i:int = 0; i < smoothingSamples; i++) {
				time += _record[index].delay;
				if (index > 0) {
					pt1.x = _record[index - 1].x;
					pt1.y = _record[index - 1].y;
					pt2.x = _record[index].x;
					pt2.y = _record[index].y;
					distance += Point.distance(pt1, pt2);
					
					index--;
				}
			}
			return (distance/smoothingSamples) / (time/smoothingSamples);
			*/
		}
		
		/////
		
		override public function destroy():void {
			super.destroy();
			for each (var stroke:Stroke in _strokes) {
				delete _strokeStatuses[stroke];
			}
			canvas = null;
			_strokes = null;
			_strokeStatuses = null;
			_pt1 = _pt2 = _pt3 = null;
		}
		
	}

}