package cl.agj.extra.interactive {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.utils.MathAgj;
	import cl.agj.extra.events.ChildSignal;
	
	/**
	 * Provides scrolling functionality for the passed target InteractiveObject, given that it's formatted correctly.
	 * The object should contain a window:DisplayObject property, which should form as a mask to the content, and
	 * a contents:DisplayObject property, the contents.
	 * 
	 * Optionally, include horizontalScrollBar:DisplayObjectContainer and/or verticalScrollBar:DisplayObjectContainer
	 * properties, formatted for compatibility with the ScrollBar class.
	 * 
	 * @author agj
	 */
	public class ScrollPanel extends Manipulable {
		
		public function ScrollPanel(target:InteractiveObject) {
			super(target);
			
			_window = _target["window"];
			_contents = _target["contents"];
			
			if (_target["horizontalScrollBar"]) {
				_scrollBarH = new ScrollBar(_target["horizontalScrollBar"], true);
				_scrollBarH.scrolled.add(onScrolled);
			} else if (_target["verticalScrollBar"]) {
				_scrollBarV = new ScrollBar(_target["verticalScrollBar"], false);
				_scrollBarV.scrolled.add(onScrolled);
			}
			
			registerListener(target, Event.ADDED, onChildAdded);
			registerListener(target, Event.REMOVED, onChildRemoved);
			
			registerListener(target, MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			updateScrollbars();
		}
		
		/////
		
		protected var _window:DisplayObject;
		protected var _contents:DisplayObject;
		protected var _scrollBarH:ScrollBar;
		protected var _scrollBarV:ScrollBar;
		
		protected var _verticalScroll:Number;
		public function get verticalScroll():Number {
			return _verticalScroll;
		}
		public function set verticalScroll(value:Number):void {
			_verticalScroll = value;
		}
		
		protected var _horizontalScroll:Number;
		public function get horizontalScroll():Number {
			return _horizontalScroll;
		}
		public function set horizontalScroll(value:Number):void {
			_horizontalScroll = value;
		}
		
		public function get amountVisibleHorizontally():Number {
			var windowSize:Rectangle = _window.getBounds(_target);
			var contentsSize:Rectangle = _contents.getBounds(_target);
			var intersection:Rectangle = windowSize.intersection(contentsSize);
			return intersection.width / contentsSize.width;
		}
		
		public function get amountVisibleVertically():Number {
			var windowSize:Rectangle = _window.getBounds(_target);
			var contentsSize:Rectangle = _contents.getBounds(_target);
			var intersection:Rectangle = windowSize.intersection(contentsSize);
			return intersection.height / contentsSize.height;
		}
		
		protected var _scrolled:ChildSignal = new ChildSignal(this);
		public function get scrolled():ChildSignal {
			return _scrolled;
		}
		
		/////
		
		public function update():void {
			updateScrollbars();
		}
		
		/////
		
		protected function scrollTo(x:Number = NaN, y:Number = NaN):void {
			var windowSize:Rectangle = _window.getBounds(_target);
			var contentsSize:Rectangle = _contents.getBounds(_contents);
			if (!isNaN(x)) {
				x = MathAgj.enforceRange(x, 0, 1);
				_contents.x = -x * Math.max(contentsSize.width - windowSize.width, 0) - contentsSize.x;
			}
			if (!isNaN(y)) {
				y = MathAgj.enforceRange(y, 0, 1);
				_contents.y = -y * Math.max(contentsSize.height - windowSize.height, 0) - contentsSize.y;
			}
		}
		
		protected function updateGraphic():void {
			var x:Number, y:Number;
			if (_scrollBarH) {
				x = _scrollBarH.scrollPosition;
			}
			if (_scrollBarV) {
				y = _scrollBarV.scrollPosition;
			}
			scrollTo(x, y);
		}
		
		protected function updateScrollbars():void {
			if (_scrollBarH) {
				_scrollBarH.amountVisible = amountVisibleHorizontally;
			}
			if (_scrollBarV) {
				_scrollBarV.amountVisible = amountVisibleVertically;
			}
		}
		
		/////
		
		protected function onScrolled(scrollBar:ScrollBar):void {
			updateGraphic();
		}
		
		protected function onChildAdded(e:Event):void {
			if (e.target === target)
				return;
			updateScrollbars();
		}
		
		protected function onChildRemoved(e:Event):void {
			if (e.target === target)
				return;
			updateScrollbars();
		}
		
		protected function onMouseWheel(e:MouseEvent):void {
			var windowSize:Rectangle = _window.getBounds(_target);
			var contentsSize:Rectangle = _contents.getBounds(_contents);
			
			scrollTo(NaN, -e.delta * 4 / Math.max(contentsSize.height - windowSize.height, 0));
			
			//_scrollBarV.scrollPosition -= e.delta * 0.02;
			//updateGraphic();
		}
		
		/////
		
		override public function destroy():void {
			Destroyer.destroy([
				_scrollBarH,
				_scrollBarV
			]);
			super.destroy();
		}
		
	}
}