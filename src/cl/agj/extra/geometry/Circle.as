package cl.agj.extra.geometry {
	
	public class Circle {
		
		protected var x:Number;
		protected var y:Number;
		protected var _radius:Number;
		protected var _diameter:Number;
		
		public function Circle(x:Number = 0, y:Number = 0, radius:Number = 0) {
			_radius = radius;
			this.x = x;
			this.y = y;
		}
		
		public function get radius():Number {
			return _radius;
		}
		public function set radius(value:Number):void {
			_radius = value;
			_diameter = NaN;
		}
		
		public function get diameter():Number {
			if (!_diameter)
				_diameter = _radius * 2;
			return _diameter;
		}
		public function set diameter(value:Number):void {
			radius = value * 0.5;
		}
		
	}
}