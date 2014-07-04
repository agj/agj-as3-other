package cl.agj.graphics.brush.vo {
	
	
	public class StrokeClone extends Stroke {
		
		protected var _original:Stroke;
		
		public function StrokeClone(original:Stroke) {
			super(original.center);
			
			_original = original;
			
			for (var i:int = 0, len:int = _original.nodes.length; i < len; i++) {
				var node:StrokeNode = _original.nodes[i];
				addNodeClone(cloneNode(node));
			}
			
			if (_original.isLive) {
				_original.modified.addOnce(onOriginalModified);
			} else {
				kill();
			}
		}
		
		/////
		
		protected function addNodeClone(clone:StrokeNode):void {
			addNode(clone);
		}
		
		protected function cloneNode(node:StrokeNode):StrokeNode {
			var clone:StrokeNode = new StrokeNode(node.x, node.y, node.delay);
			clone.data = node.data;
			return clone;
		}
		
		/////
		
		private function onOriginalModified(o:Stroke):void {
			for (var i:int = nodes.length, len:int = _original.nodes.length; i < len; i++) {
				var node:StrokeNode = _original.nodes[i];
				addNodeClone(cloneNode(node));
			}
			if (_original.isLive) {
				_original.modified.addOnce(onOriginalModified);
			}
		}
		
	}
}