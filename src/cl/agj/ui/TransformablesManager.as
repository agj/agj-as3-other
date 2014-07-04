package cl.agj.ui {
	import cl.agj.core.display.TidyGraphic;
	import cl.agj.graphics.ColorUtil;
	import cl.agj.graphics.Draw;
	import cl.agj.graphics.DrawStyle;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TransformablesManager extends TidyGraphic {
		
		protected var _handles:Vector.<Sprite>;
		
		protected var _selectedObject:ITransformable;
		protected var _draggingHandle:int;
		protected var _draggingObject:Boolean;
		protected var _objectDragPt:Point
		protected var _lineStyle:DrawStyle;
		
		public function TransformablesManager() {
			_draggingHandle = -1;
			_objectDragPt = new Point;
			
			_handles = new Vector.<Sprite>;
			var drawStyle:DrawStyle = new DrawStyle(0x00ffff, 1);
			var rectangle:Rectangle = new Rectangle(-5, -5, 10, 10);
			var handle:Sprite;
			for (var i:uint; i < 4; i++) {
				handle = new Sprite;
				Draw.rectangle(handle.graphics, drawStyle, rectangle);
				_handles.push(handle);
			}
			
			_lineStyle = DrawStyle.makeLineStyle(0x00ffff, 1, 1);
			
			super();
		}
		
		override protected function init():void {
			registerListener(stage, MouseEvent.MOUSE_DOWN, onMouseDown);
			registerListener(stage, MouseEvent.MOUSE_UP, onMouseUp, false, int.MIN_VALUE);
			registerListener(stage, MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		/////
		
		protected function clear():void {
			graphics.clear();
			for each (var h:Sprite in _handles) {
				if (h.parent === this)
					removeChild(h);
			}
		}
		
		protected function setHandles():void {
			clear();
			
			Draw.polyLine(graphics, _lineStyle, _selectedObject.corners, true);
			
			var handle:Sprite, pt:Point;
			for (var i:uint = 0; i < 4; i++) {
				handle = _handles[i];
				pt = _selectedObject.corners[i];
				if (handle.parent !== this)
					addChild(handle);
				handle.x = pt.x;
				handle.y = pt.y;
			}
		}
		
		/////
		
		protected function onMouseDown(e:MouseEvent):void {
			var object:Object = e.target;
			while (object.parent) {
				if (object is Transformable)
					break;
				object = object.parent;
			}
			
			if (object is Transformable && (object.allowsTransformation || object.allowsDrag)) {
				_selectedObject = ITransformable(object);
				if (_selectedObject.allowsDrag) {
					_draggingObject = true;
					_objectDragPt.x = _selectedObject.x;
					_objectDragPt.y = _selectedObject.y;
					_objectDragPt = _selectedObject.parent.localToGlobal(_objectDragPt);
					_objectDragPt.x = mouseX - _objectDragPt.x;
					_objectDragPt.y = mouseY - _objectDragPt.y;
				}
				if (_selectedObject.allowsTransformation)
					setHandles();
			} else if (_selectedObject) {
				if (_handles.indexOf(e.target) >= 0) {
					_draggingHandle = _handles.indexOf(e.target);
				} else {
					clear();
					_selectedObject = null;
				}
			}
		}
		
		protected function onMouseUp(e:MouseEvent):void {
			_draggingHandle = -1;
			_draggingObject = false;
			if (_selectedObject && !_selectedObject.parent) {
				clear();
				_selectedObject = null;
			}
		}
		
		protected function onMouseMove(e:MouseEvent):void {
			if (_draggingHandle >= 0) {
				_selectedObject.dragCorner(_draggingHandle, new Point(mouseX, mouseY));
				setHandles();
			} else if (_draggingObject) {
				var newPos:Point = new Point(mouseX - _objectDragPt.x, mouseY - _objectDragPt.y);
				newPos = _selectedObject.parent.globalToLocal(newPos);
				_selectedObject.x = newPos.x;
				_selectedObject.y = newPos.y;
				setHandles();
			}/* else if (stage) {
				var objs:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
				if (objs.length > 0) {
					var target:DisplayObject = objs[0];
					if (target.name)
						trace(target.name);
					if (target is ITransformable) {
						ColorUtil.tint(DisplayObject(target), 0xffffff);
					}
				}
			}*/
		}
		
	}
}