package cl.agj.graphics.brush.engine {
	import cl.agj.engine.ICog;
	import cl.agj.graphics.brush.StrokeGenerator;
	
	import flash.events.KeyboardEvent;
	
	/**
	 * I don't think that this class has any reason existing? Deprecated.
	 */
	public class StrokeGeneratorCog extends StrokeGenerator implements ICog {
		
		protected var _lastTick:uint;
		protected var _localTime:uint;
		
		public function StrokeGeneratorCog() {
			super();
		}
		
		/////
		
		protected function getCurrentTime():uint {
			return _localTime;
		}
		
		/////
		
		public function onEnterFrame(elapsed:uint):void {
			if (_isDestroyed)
				return;
			_lastTick = _localTime;
			_localTime += elapsed;
		}
		
		public function onKeyDown(key:uint, char:String, e:KeyboardEvent):void { }
		
		public function onKeyUp(key:uint, char:String, e:KeyboardEvent):void { }
		
	}
}