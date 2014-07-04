package cl.agj.extra.interactive {
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.extra.events.ChildSignal;
	
	public class Clickable extends Manipulable {
		
		public function Clickable(target:InteractiveObject) {
			super(target);
			
			if (target is Sprite) {
				target["useHandCursor"] = true;
				target["buttonMode"] = true;
			}
			
			registerListener(_target, MouseEvent.CLICK, onClick);
			registerListener(_target, MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/////
		
		protected var _isPressed:Boolean = false;
		public function get isPressed():Boolean {
			return _isPressed;
		}
		
		protected var _hasCursorOver:Boolean = false;
		public function get hasCursorOver():Boolean {
			return _hasCursorOver;
		}
		
		protected var _clicked:ChildSignal = new ChildSignal(this);
		public function get clicked():ChildSignal {
			return _clicked;
		}
		
		protected var _doubleClicked:ChildSignal;
		public function get doubleClicked():ChildSignal {
			if (!_doubleClicked) {
				_doubleClicked = new ChildSignal(this);
				_target.doubleClickEnabled = true;
				registerListener(_target, MouseEvent.DOUBLE_CLICK, onDoubleClick);
			}
			return _doubleClicked;
		}
		
		protected var _pressed:ChildSignal = new ChildSignal(this);
		public function get pressed():ChildSignal {
			return _pressed;
		}
		
		protected var _released:ChildSignal = new ChildSignal(this);
		public function get released():ChildSignal {
			return _released;
		}
		
		protected var _cursorEntered:ChildSignal = new ChildSignal(this);
		public function get cursorEntered():ChildSignal {
			return _cursorEntered;
		}
		
		protected var _cursorExited:ChildSignal = new ChildSignal(this);
		public function get cursorExited():ChildSignal {
			return _cursorExited;
		}
		
		/////
		
		protected function onClick(e:MouseEvent):void {
			_clicked.dispatch();
		}
		
		protected function onDoubleClick(e:MouseEvent):void {
			_doubleClicked.dispatch();
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			registerListener(_target.stage, MouseEvent.MOUSE_UP, onMouseUp);
			registerListener(_target, MouseEvent.ROLL_OVER, onMouseOver);
			registerListener(_target, MouseEvent.ROLL_OUT, onMouseOut);
			_isPressed = true;
			_pressed.dispatch();
		}
		
		protected function onMouseUp(e:MouseEvent):void {
			unregisterListener(_target.stage, MouseEvent.MOUSE_UP, onMouseUp);
			unregisterListener(_target, MouseEvent.ROLL_OVER, onMouseOver);
			unregisterListener(_target, MouseEvent.ROLL_OUT, onMouseOut);
			_isPressed = false;
			_released.dispatch();
		}
		
		protected function onMouseOver(e:MouseEvent):void {
			_hasCursorOver = true;
			_cursorEntered.dispatch();
		}
		
		protected function onMouseOut(e:MouseEvent):void {
			if (_hasCursorOver) {
				_hasCursorOver = false;
				if (!_isPressed)
					_cursorExited.dispatch();
			}
		}
		
		/////
		
		override public function destroy():void {
			Destroyer.destroy([
				_clicked,
				_doubleClicked,
				_pressed,
				_released,
				_cursorEntered,
				_cursorExited
			]);
			_clicked = null;
			_doubleClicked = null;
			_pressed = null;
			_released = null;
			_cursorEntered = null;
			_cursorExited = null;
			super.destroy();
		}
		
	}
}