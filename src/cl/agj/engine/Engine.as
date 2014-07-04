package cl.agj.engine {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import cl.agj.core.display.TidyGraphic;
	import cl.agj.core.utils.Destroyer;
	
	public class Engine extends TidyGraphic {
		
		protected var _state:IState;
		
		protected var _autoPause:Boolean;
		protected var _usePerFrameUpdate:Boolean;
		protected var _frameRate:Number;
		
		protected var _paused:Boolean;
		protected var _pauseStateClass:Class;
		protected var _pauseState:IState;
		
		protected var _time:uint;
		protected var _lastTick:uint;
		
		public function Engine(autoPause:Boolean = true, usePerFrameUpdate:Boolean = true) {
			_autoPause = autoPause;
			_usePerFrameUpdate = usePerFrameUpdate;
			super();
		}
		
		override protected function init():void {
			_time = getTimer();
			
			// Events.
			if (_usePerFrameUpdate)
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			registerListener(stage, Event.RESIZE, onStageResize);
			registerListener(stage, Event.ACTIVATE, onFocusGained);
			registerListener(stage, Event.DEACTIVATE, onFocusLost);
			//registerListener(stage, MouseEvent.MOUSE_DOWN, onMouseDown);
			//registerListener(stage, MouseEvent.MOUSE_UP, onMouseUp);
			registerListener(stage, KeyboardEvent.KEY_DOWN, onKeyDown);
			registerListener(stage, KeyboardEvent.KEY_UP, onKeyUp);
			
			unpause();
		}
		
		protected function update(elapsed:uint):void {
			
		}
		
		///////
		
		protected function changeState(newState:IState):void {
			if (_state) {
				_state.destroy();
				stage.focus = null;
			}
			_state = newState;
			addChild(_state as DisplayObject);
			
			_state.restarted.add(restartState);
		}
		
		protected function restartState():void {
			var stateClass:Class = Class(getDefinitionByName(getQualifiedClassName(_state)));
			changeState(new stateClass);
		}
		
		protected function setPauseState(stateClass:Class):void {
			_pauseStateClass = stateClass;
			if (_paused) {
				removePauseState();
				addPauseState();
			}
		}
		
		protected function pause():void {
			_paused = true;
			removePauseState();
			addPauseState();
			_frameRate = stage.frameRate;
			stage.frameRate = 5;
		}
		
		protected function unpause():void {
			_paused = false;
			if (!isNaN(_frameRate))
				stage.frameRate = _frameRate;
			removePauseState();
		}
		
		protected function removePauseState():void {
			if (_pauseState)
				_pauseState.destroy();
		}
		protected function addPauseState():void {
			if (_pauseStateClass) {
				_pauseState = new _pauseStateClass as IState;
				addChild(_pauseState as DisplayObject);
			}
		}
		
		///////
		
		protected function onEnterFrame(e:Event):void {
			var elapsed:uint = getTimer() - _time;
			_lastTick = _time;
			_time += elapsed;
			
			if (!_paused) {
				update(elapsed);
				if (_state)
					_state.onEnterFrame(elapsed);
			}
		}
		
		protected function onStageResize(e:Event):void {
			if (_state)
				_state.onStageResized();
		}
		
		protected function onFocusGained(e:Event):void {
			_focused = true;
			if (_autoPause)
				unpause();
			else
				notifyFocus();
		}
		protected function onFocusLost(e:Event):void {
			_focused = false;
			if (_autoPause)
				pause();
			else
				notifyFocus();
		}
		protected function notifyFocus():void {
			if (_state)
				_state.onFocusChange(_focused);
		}
		
		/*
		protected function onMouseDown(e:MouseEvent):void {
			_mouseDown = true;
			if (_state)
				_state.onMouseDown(e, new Point(stage.mouseX, stage.mouseY));
		}
		protected function onMouseMove(e:MouseEvent):void {
			if (_state)
				_state.onMouseMove(e, new Point(stage.mouseX, stage.mouseY));
		}
		protected function onMouseUp(e:MouseEvent):void {
			_mouseDown = false;
			if (_state)
				_state.onMouseUp(e, new Point(stage.mouseX, stage.mouseY));
		}
		*/
		
		protected function onKeyDown(e:KeyboardEvent):void {
			var char:String = String.fromCharCode(e.charCode);
			Input.press(e.keyCode, char);
			if (_state)
				_state.onKeyDown(e.keyCode, char, e);
		}
		protected function onKeyUp(e:KeyboardEvent):void {
			var char:String = String.fromCharCode(e.charCode);
			Input.release(e.keyCode, char);
			if (_state)
				_state.onKeyUp(e.keyCode, char, e);
		}
		
		///////
		
		private static var _focused:Boolean;
		//private static var _mouseDown:Boolean;
		
		public static function get focused():Boolean {
			return _focused;
		}
		/*
		public static function get mouseDown():Boolean {
			return _mouseDown;
		}
		*/
		
		///////
		
		override public function destroy():void {
			super.destroy();
			Destroyer.destroy([
				_state,
				_pauseState
			]);
			_state = null;
			_pauseState = null;
			_pauseStateClass = null;
		}
		
	}
}