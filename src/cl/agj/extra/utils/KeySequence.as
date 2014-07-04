package cl.agj.extra.utils {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	
	import cl.agj.core.TidyListenerRegistrar;
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.utils.ListUtil;
	
	import org.osflash.signals.Signal;
	
	public class KeySequence extends TidyListenerRegistrar {
		
		public function KeySequence() {
			_sequences = new Vector.<String>;
			_written = "";
		}
		
		/////
		
		public function listen(secuencia:String):void {
			initialize();
			if (!ListUtil.has(_sequences, secuencia))
				_sequences.push(secuencia);
		}
		
		public function stopListening(secuencia:String):void {
			ListUtil.remove(_sequences, secuencia);
		}
		
		/////
		
		protected var _sequences:Vector.<String>;
		protected var _stage:Stage;
		protected var _initialized:Boolean;
		
		protected var _written:String;
		protected var _lastTime:uint;
		
		public function get stage():Stage {
			return _stage;
		}
		public function set stage(value:Stage):void {
			_stage = value;
			initialize();
		}
		
		protected var _llamado:Signal = new Signal(String);
		/** Firma: secuencia:String */
		public function get called():Signal {
			return _llamado;
		}
		
		/////
		
		protected function initialize():void {
			if (!_initialized && _stage) {
				registerListener(stage, KeyboardEvent.KEY_DOWN, alTeclear);
				_initialized = true;
			}
		}
		
		protected function checkSequences():void {
			for each (var secuencia:String in _sequences) {
				if (_written.substr(-secuencia.length, secuencia.length) === secuencia) {
					_llamado.dispatch(secuencia);
				}
			}
		}
		
		/////
		
		protected function alTeclear(e:KeyboardEvent):void {
			var tiempo:uint = getTimer();
			if (tiempo - _lastTime > 1000)
				_written = "";
			_written += String.fromCharCode(e.charCode).toLowerCase();
			checkSequences();
			_lastTime = tiempo;
		}
		
		/////
		
		override public function destroy():void {
			super.destroy();
			Destroyer.destroy([
				_llamado
			]);
			_llamado = null;
		}
		
		
	}
}