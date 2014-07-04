package cl.agj.transitions {
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.display.TidyGraphic;
	import cl.agj.graphics.Canvas;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;
	
	/**
	 * Class to base a seamless transition between states. As it is, it does nothing.
	 * This class uses a transparency-enabled Canvas object that the constructor paints
	 * the stage on, which can then be faded or distorted in some way, before dispatching
	 * the 'finished' signal.
	 */
	public class AbstractSeamlessTransition extends TidyGraphic implements ITransition {
		
		internal const CLASS_NAME:String = "cl.agj.transitions::AbstractSeamlessTransition";
		
		/**
		 * This signal is dispatched when the transition is finished.
		 */
		public var _finished:Signal;
		
		/**
		 * This flag is set to 'true' when the transition has finished.
		 */
		protected var _isFinished:Boolean;
		protected var _snapshot:Canvas;
		protected var _localTime:uint;
		protected var _lastTick:uint;
		
		public function AbstractSeamlessTransition(stageObj:Stage) {
			super();
			
			if (getQualifiedClassName(this) == CLASS_NAME) {
            	throw new Error("This is an abstract class and is not meant for instantiation; it should only be extended.");
			}
			
			_finished = new Signal;
			
			_snapshot = new Canvas(stageObj.stageWidth, stageObj.stageHeight, 0xffffff, true);
			_snapshot.bitmapData.draw(stageObj, null, null, null, new Rectangle(0, 0, _snapshot.width, _snapshot.height));
			addChild(_snapshot);
		}
		
		override protected function init():void {
			// Events.
			registerListener(stage, Event.RESIZE, onResize);
		}
		
		public function update(elapsed:uint):void {
			_lastTick = _localTime;
			_localTime += elapsed;
		}
		
		/**
		 * Call this function when your transition has finished.
		 */
		protected function onFinished():void {
			_isFinished = true;
			//_snapshot.bitmapData.dispose();
			//removeChild(_snapshot);
			//_snapshot = null;
			_finished.dispatch();
			destroy();
		}
		
		protected function onResize():void {
			// This here is an ugly way to cope with stage resizing.
			if (stage) {
				_snapshot.width = stage.stageWidth;
				_snapshot.height = stage.stageHeight;
			}
		}
		
		/////
		
		public function get finished():Signal {
			return _finished;
		}
		
		/////
		
		override public function destroy():void {
			Destroyer.destroy([
				_finished,
				_snapshot
			]);
			super.destroy();
		}
		
	}
}