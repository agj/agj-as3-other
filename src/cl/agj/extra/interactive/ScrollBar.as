package cl.agj.extra.interactive {
	import flash.display.InteractiveObject;
	import flash.geom.Rectangle;
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.utils.MathAgj;
	import cl.agj.extra.events.ChildSignal;
	
	/**
	 * Makes the passed target InteractiveObject work as a scrollbar, provided it is formatted correctly.
	 * Include a handle:InteractiveObject property for the scrollbar handle, and a track:InteractiveObject
	 * for the track behind it. The handle's registration point must be at its top left.
	 * 
	 * @author agj
	 */
	public class ScrollBar extends Manipulable {
		
		public function ScrollBar(target:InteractiveObject, horizontal:Boolean = false) {
			super(target);
			
			_horizontal = horizontal;
			_handle = new Draggable(_target["handle"]);
			_track = _target["track"];
			
			_trackPosition = horizontal ? _handle.target.y : _handle.target.x;
			_minimumSize = Math.min(_minimumSize, _horizontal ? _track.width : _track.height);
			_trackSize = _track.getBounds(_track);
			
			_handle.moved.add(onHandleDragged);
			
			update();
		}
		
		/////
		
		protected var _trackPosition:Number;
		protected var _minimumSize:Number = 40;
		protected var _trackSize:Rectangle;
		
		protected var _handle:Draggable;
		protected var _track:InteractiveObject;
		
		protected var _horizontal:Boolean;
		public function get horizontal():Boolean {
			return _horizontal;
		}
		
		protected var _scrollPosition:Number = 0;
		public function get scrollPosition():Number {
			return _scrollPosition;
		}
		public function set scrollPosition(value:Number):void {
			_scrollPosition = MathAgj.enforceRange(value, 0, 1);
			update();
		}
		
		protected var _amountVisible:Number = 1;
		public function get amountVisible():Number {
			return _amountVisible;
		}
		public function set amountVisible(value:Number):void {
			_amountVisible = MathAgj.enforceRange(value, 0, 1);
			update();
		}
		
		protected var _scrolled:ChildSignal = new ChildSignal(this);
		public function get scrolled():ChildSignal {
			return _scrolled;
		}
		
		/////
		
		protected function update():void {
			var handle:InteractiveObject = _handle.target;
			if (_horizontal) {
				var w:Number = Math.max(_trackSize.width * _amountVisible, _minimumSize);
				handle.width = w;
				handle.x = _trackSize.left + _scrollPosition * (_trackSize.width - w);
			} else {
				var h:Number = Math.max(_trackSize.height * _amountVisible, _minimumSize);
				handle.height = h;
				handle.y = _trackSize.top + _scrollPosition * (_trackSize.height - h);
			}
		}
		
		protected function snap():void {
			var handle:InteractiveObject = _handle.target;
			if (_horizontal) {
				handle.y = _trackPosition;
				handle.x = MathAgj.enforceRange(handle.x, _trackSize.left, _trackSize.right - handle.width);
			} else {
				handle.x = _trackPosition;
				handle.y = MathAgj.enforceRange(handle.y, _trackSize.top, _trackSize.bottom - handle.height);
			}
		}
		
		protected function updateScrollValue():void {
			var handle:InteractiveObject = _handle.target;
			if (_horizontal) {
				_scrollPosition = MathAgj.enforceRange((handle.x - _trackSize.left) / Math.max(_trackSize.width - handle.width, 0), 0, 1);
			} else {
				_scrollPosition = MathAgj.enforceRange((handle.y - _trackSize.top) / Math.max(_trackSize.height - handle.height, 0), 0, 1);
			}
		}
		
		/////
		
		protected function onHandleDragged(handle:Draggable):void {
			var oldScrollPosition:Number = _scrollPosition;
			snap();
			updateScrollValue();
			//update();
			if (_scrollPosition != oldScrollPosition)
				_scrolled.dispatch();
		}
		
		/////
		
		override public function destroy():void {
			Destroyer.destroy([
				_handle,
				_scrolled
			]);
			super.destroy();
		}
		
	}
}