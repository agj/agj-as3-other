package cl.agj.graphics.brush {
	import cl.agj.core.Destroyable;
	import cl.agj.core.utils.ListUtil;
	import cl.agj.graphics.brush.vo.Stroke;
	import cl.agj.graphics.brush.vo.StrokeNode;
	import cl.agj.graphics.brush.vo.StrokeStatus;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * Used for generating vo.Stroke objects, which can be fed into StrokePlay to create drawings.
	 */
	public class StrokeGenerator extends Destroyable {
		
		protected var _strokes:Vector.<Stroke> = new Vector.<Stroke>;
		protected var _strokeStatuses:Dictionary = new Dictionary;
		
		public function StrokeGenerator() {
			super();
		}
		
		/////
		
		/**
		 * @return		A stroke object including one StrokeNode, to be passed later to extendStroke() and endStroke().
		 */
		public function startStroke(x:Number, y:Number):Stroke {
			var stroke:Stroke = new Stroke(new Point(x, y));
			stroke.addNode(new StrokeNode(0, 0, 0));
			_strokes.push(stroke);
			
			var status:StrokeStatus = new StrokeStatus;
			status.startTime = status.previousTime = getTimer();
			_strokeStatuses[stroke] = status;
			
			return stroke;
		}
		
		/**
		 * @return		The StrokeNode added to the Stroke.
		 */
		public function extendStroke(stroke:Stroke, x:Number, y:Number):StrokeNode {
			assert(stroke, stroke.isLive, _strokes.indexOf(stroke) >= 0);
			
			var time:int = getTimer();
			
			var status:StrokeStatus = _strokeStatuses[stroke];
			var node:StrokeNode = new StrokeNode(x - stroke.center.x, y - stroke.center.y, time - status.previousTime);
			stroke.addNode(node);
			status.previousTime = time;
			
			return node;
		}
		
		public function endStroke(stroke:Stroke):void {
			assert(stroke, _strokes.indexOf(stroke) >= 0);
			
			stroke.kill();
			ListUtil.remove(_strokes, stroke);
			delete _strokeStatuses[stroke];
		}
		
		/////
		
		protected function assert(...values):void {
			for each (var value:* in values) {
				if (!value) throw new ArgumentError;
			}
		}
		
		/////
		
		override public function destroy():void {
			super.destroy();
			for each (var stroke:Stroke in _strokes) {
				delete _strokeStatuses[stroke];
			}
			_strokes = null;
			_strokeStatuses = null;
		}
		
	}
}