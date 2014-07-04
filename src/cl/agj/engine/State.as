package cl.agj.engine {
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.display.TidyGraphic;
	import cl.agj.core.utils.ListUtil;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;
	
	public class State extends Bug implements IState {
		
		protected var _finished:Signal;
		protected var _selected:Signal;
		protected var _restarted:Signal;
		
		public function State() {
			_finished = new Signal;
			_selected = new Signal(String);
			_restarted = new Signal;
			
			super();
		}
		
		/////////
		
		public function get finished():Signal {
			return _finished;
		}
		
		public function get selected():Signal {
			return _selected;
		}
		
		public function get restarted():Signal {
			return _restarted;
		}
		
		/////////
			
		override public function destroy():void {
			Destroyer.destroy([
				_finished,
				_selected,
				_restarted
			]);
			super.destroy();
		}
		
	}
}