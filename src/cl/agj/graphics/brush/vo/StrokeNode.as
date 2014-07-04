package cl.agj.graphics.brush.vo {
	
	public class StrokeNode {
		
		public var x:Number;
		public var y:Number;
		public var delay:Number;
		
		protected var _data:Object;
		
		public function StrokeNode(x:Number = 0, y:Number = 0, delay:Number = NaN) {
			this.x = x;
			this.y = y;
			this.delay = delay;
		}
		
		public function get data():Object {
			return _data ||= {};
		}
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function toString():String {
			return "[" + x + "," + y + " " + delay + "]";
		}
		
	}
}