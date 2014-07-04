package cl.agj.graphics.brush {
	import cl.agj.core.TidyListenerRegistrar;
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.utils.MathAgj;
	import cl.agj.extra.events.ChildSignal;
	import cl.agj.graphics.DrawStyle;
	import cl.agj.graphics.Paint;
	import cl.agj.graphics.brush.vo.Stroke;
	import cl.agj.graphics.brush.vo.StrokeNode;
	import cl.agj.graphics.brush.vo.StrokeStyle;
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	
	public class StrokePlayer extends TidyListenerRegistrar {
		
		protected var _finished:ChildSignal = new ChildSignal(this);
		
		protected var _stroke:Stroke;
		protected var _surface:BitmapData;
		protected var _strokeStyle:StrokeStyle;
		
		protected var _timer:Timer = new Timer(0, 1);
		protected var _nodeIndex:int = 0;
		protected var _drawTime:uint = 0;
		
		private var
			_ds:DrawStyle = new DrawStyle,
			_pt1:Point = new Point,
			_pt2:Point = new Point;
		
		public function StrokePlayer(stroke:Stroke, surface:BitmapData, strokeStyle:StrokeStyle = null, delay:uint = 0) {
			assert(stroke, surface);
			
			super();
			
			_stroke = stroke;
			_surface = surface;
			_strokeStyle = strokeStyle ||= new StrokeStyle();
			
			registerListener(_timer, TimerEvent.TIMER, onTimer);
			
			_drawTime = getTimer() + delay;
			wait();
		}
		
		/////
		
		public function get stroke():Stroke {
			return _stroke;
		}
		
		public function get finished():ChildSignal {
			return _finished;
		}
		
		/////
		
		protected function takeStep():void {
			calculateDraw(_stroke.nodes, _nodeIndex, _stroke.center, _strokeStyle);
			_nodeIndex++;
			wait();
		}
		
		protected function wait():void {
			if (_nodeIndex < _stroke.nodes.length) {
				var now:uint = getTimer();
				var node:StrokeNode = _stroke.nodes[_nodeIndex];
				
				_drawTime = _drawTime + node.delay;
				
				if (_drawTime <= now) {
					takeStep();
				} else {
					_timer.delay = _drawTime - now;
					_timer.start();
				}
			} else if (_stroke.isLive) {
				_stroke.modified.addOnce(onLiveStrokeModified);
			} else if (_nodeIndex === _stroke.nodes.length) {
				takeStep();
				_finished.dispatch();
				destroy();
			}
		}
		
		/////
		
		protected function calculateDraw(nodes:Vector.<StrokeNode>, nodeIndex:uint, center:Point, style:StrokeStyle):void {
			var len:uint = nodes.length;
			var isEnd:Boolean = nodeIndex === len;
			if (nodeIndex < 1 && !isEnd)
				return;
			
			// Determine points.
			var pt1:Point, pt2:Point, pt3:Point;
			var idx:uint = nodeIndex;
			if (!isEnd) {
				pt3 = new Point(nodes[idx].x, nodes[idx].y);
			}
			if (idx > 0)
				idx--;
			pt2 = new Point(nodes[idx].x, nodes[idx].y);
			if (idx > 0)
				idx--;
			pt1 = new Point(nodes[idx].x, nodes[idx].y);
			
			executeDraw(nodes, nodeIndex, center, pt1, pt2, pt3, style, isEnd);
		}
		
		protected function executeDraw(nodes:Vector.<StrokeNode>, nodeIndex:uint, center:Point, pt1:Point, pt2:Point, pt3:Point, style:StrokeStyle, end:Boolean):void {
			var startIndex:uint = Math.max(nodeIndex - style.smoothingSamples, 0);
			var sampleNodes:Vector.<StrokeNode> = nodes.slice(startIndex, nodeIndex + 1);
			
			var speed:Number = getAverageSpeed(sampleNodes);
			var weight:Number = getWeightModifiedBySpeed(style.drawStyle.lineWeight, speed, style.weightStability, style.peakWeightFactor);
			
			if (!end)
				drawCurve(_surface, center, pt1, pt2, pt3, style.drawStyle.lineColor, style.drawStyle.lineAlpha, weight);
			else
				drawEnd(_surface, center, pt1, pt2, style.drawStyle.lineColor, style.drawStyle.lineAlpha, weight);
		}
		
		protected function drawCurve(surface:BitmapData, center:Point, pt1:Point, pt2:Point, pt3:Point, color:uint, alpha:Number, weight:Number):void {
			var ptA:Point, ptB:Point;
			
			if (pt3) {
				ptA = Point.interpolate(pt1, pt2, 0.5);
				ptB = Point.interpolate(pt2, pt3, 0.5);
				_ds.setLine(color, weight, alpha, CapsStyle.ROUND);
				if (Point.distance(ptA, pt2) + Point.distance(pt2, ptB) > 5)
					Paint.drawCurve(surface, _ds, ptA.x + center.x, ptA.y + center.y, pt2.x + center.x, pt2.y + center.y, ptB.x + center.x, ptB.y + center.y);
				else
					Paint.drawLine(surface, _ds, ptA.x + center.x, ptA.y + center.y, ptB.x + center.x, ptB.y + center.y);
			} else {
				Paint.drawLine(surface, _ds, pt1.x + center.x, pt1.y + center.y, pt2.x + center.x, pt2.y + center.y);
			}
		}
		
		protected function drawEnd(surface:BitmapData, center:Point, pt1:Point, pt2:Point, color:uint, alpha:Number, weight:Number):void {
			var ptA:Point = Point.interpolate(pt1, pt2, 0.5);
			_ds.setLine(color, weight, alpha, CapsStyle.ROUND);
			Paint.drawLine(surface, _ds, ptA.x + center.x, ptA.y + center.y, pt2.x + center.x, pt2.y + center.y);
		}
		
		protected function getAverageSpeed(nodes:Vector.<StrokeNode>):Number {
			var time:uint = 0;
			var distance:Number = 0;
			var samples:uint = nodes.length;
			
			for (var i:int = 0; i < samples; i++) {
				time += nodes[i].delay;
				if (i > 0) {
					setPoint(_pt1, nodes[i - 1].x, nodes[i - 1].y);
					setPoint(_pt2, nodes[i].x, nodes[i].y);
					distance += Point.distance(_pt1, _pt2);
				}
			}
			
			return samples > 0 ? (distance/samples) / (time/samples) : 0;
		}
		
		protected function getWeightModifiedBySpeed(weight:Number, speed:Number, weightStability:Number, peakWeightFactor:Number):Number {
			var result:Number;
			if (speed === 0 || isNaN(speed))
				result = weight;
			else
				result = weight * MathAgj.curve(speed, weightStability, peakWeightFactor);
			return result;
		}
		
		protected function setPoint(point:Point, x:Number, y:Number):Point {
			point.x = x;
			point.y = y;
			return point;
		}
		
		/////
		
		protected function onTimer(e:TimerEvent):void {
			_timer.stop();
			_timer.reset();
			takeStep();
		}
		
		protected function onLiveStrokeModified(stroke:Stroke):void {
			wait();
		}
		
		protected function assert(...values):void {
			for each (var value:* in values) {
				if (!value) throw new ArgumentError;
			}
		}
		
		/////
		
		override public function destroy():void {
			super.destroy();
			Destroyer.destroy([
				_finished,
				_timer
			]);
			_finished = null;
			_stroke = null;
			_surface = null;
			_timer = null;
		}
		
	}
}