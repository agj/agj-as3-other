package cl.agj.graphics.brush.vo {
	import cl.agj.core.utils.Delay;
	import cl.agj.extra.events.ChildSignal;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	public class Stroke {
		
		protected var _modified:ChildSignal;
		
		public var center:Point;
		public var nodes:Vector.<StrokeNode>;
		
		protected var _isLive:Boolean = true;
		
		public function Stroke(center:Point) {
			this.center = center;
			this.nodes = new Vector.<StrokeNode>;
		}
		
		/**
		 * Adds a node to the 'nodes' vector, then triggers the 'modified' signal.
		 */
		public function addNode(node:StrokeNode):void {
			if (!_isLive)
				throw new IllegalOperationError("This stroke has been killed, so you cannot add nodes to it.");
			nodes.push(node);
			waitCallModified();
		}
		
		/**
		 * Turns the 'isLive' property to false, then triggers the 'modified' signal.
		 */
		public function kill():void {
			if (!_isLive)
				throw new IllegalOperationError("The stroke has already been killed.");
			_isLive = false;
			waitCallModified();
		}
		
		/////
		
		public function get isLive():Boolean {
			return _isLive;
		}
		
		public function get modified():ChildSignal {
			return _modified ||= new ChildSignal(this);
		}
		
		public function toString():String {
			return "[" + center.x + "," + center.y + "]";
		}
		
		/////
		
		protected function waitCallModified():void {
			if (_modified && _modified.numListeners > 0)
				Delay.tillLater(callModified, 0);
		}
		protected function callModified():void {
			_modified.dispatch();
		}
		
		
	}
}