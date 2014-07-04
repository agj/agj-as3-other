package cl.agj.scaler {
	
	import cl.agj.core.TidyEventDispatcher;
	import cl.agj.core.utils.MathAgj;
	
	import flash.display.BitmapData;
	
	public class Scaler extends TidyEventDispatcher {
		
		public var bitmapData:BitmapData;
		public var distance:Number;
		public var view:Number;
		public var x:Number;
		public var y:Number;
		
		private var _scalables:ScalableManager;
		
		public function Scaler(bitmapData:BitmapData) {
			this.bitmapData = bitmapData;
			
			_scalables = new ScalableManager;
			distance = 0;
			x = 0;
			y = 0;
			view = 10000;
			
			super();
		}
		
		public function move(distance:Number, x:Number, y:Number):void {
			this.distance = distance;
			this.x = x;
			this.y = y;
		}
		
		public function update():void {
			
		}
		
		private function updateItems():void {
			
		}
		
		public function render():void {
			var list:Vector.<IScalable> = _scalables.getList(distance, distance + view);
			var factor:Number;
			for each (var s:IScalable in list) {
				factor = MathAgj.curve(s.distance, 10);
				s.render(bitmapData, s.x * factor, s.y * factor, factor);
			}
		}
		
		/////////
		
		public function collideGroups(groupA:String, groupB:String):void {
			
		}
		
		public function collideScalables(scalableA:IScalable, scalableB:IScalable):void {
			
		}
		
		public function collideMix(scalable:IScalable, group:String):void {
			
		}
		
		/////////
		
		public function get scalables():ScalableManager {
			return _scalables;
		}
		
	}
}