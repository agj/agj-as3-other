package cl.agj.extra.interactive {
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import cl.agj.extra.events.ChildSignal;
	
	public class Draggable extends Clickable {
		
		public function Draggable(target:InteractiveObject) {
			super(target);
		}
		
		override protected function init():void {
			
		}
		
		/////
		
		protected var _clickPoint:Point = new Point;
		
		protected var _moved:ChildSignal = new ChildSignal(this);
		public function get moved():ChildSignal {
			return _moved;
		}
		
		/////
		
		override protected function onMouseDown(e:MouseEvent):void {
			_clickPoint.x = _target.x - _target.parent.mouseX;
			_clickPoint.y = _target.y - _target.parent.mouseY;
			
			registerListener(_target.stage, MouseEvent.MOUSE_MOVE, onMouseMove);
			super.onMouseDown(e);
		}
		
		protected function onMouseMove(e:MouseEvent):void {
			_target.x = _target.parent.mouseX + _clickPoint.x;
			_target.y = _target.parent.mouseY + _clickPoint.y;
			_moved.dispatch();
		}
		
		override protected function onMouseUp(e:MouseEvent):void {
			unregisterListener(_target.stage, MouseEvent.MOUSE_MOVE, onMouseMove);
			super.onMouseUp(e);
		}
		
	}
}