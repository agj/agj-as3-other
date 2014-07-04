package cl.agj.ui {
	
	import cl.agj.engine.Input;
	import cl.agj.core.display.TidyGraphic;
	import cl.agj.core.utils.MathAgj;
	import cl.agj.core.debugging.Logger;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	public class Transformable extends TidyGraphic implements ITransformable {
		
		protected var _allowsTransformation:Boolean;
		protected var _allowsDrag:Boolean;
		protected var _minScale:Number;
		protected var _maxScale:Number;
		
		private var _cornersContainer:Sprite;
		private var _corners:Vector.<Shape>;
		private var _cornerPts:Vector.<Point>;
		
		public function Transformable() {
			_allowsTransformation = _allowsDrag = true;
			_minScale = 0;
			_maxScale = 10000;
			
			_cornersContainer = new Sprite;
			addChild(_cornersContainer);
			
			_corners = new Vector.<Shape>;
			_cornerPts = new Vector.<Point>;
			var corner:Shape;
			for (var i:uint = 0; i < 4; i++) {
				corner = new Shape;
				_cornersContainer.addChild(corner);
				_corners.push(corner);
				_cornerPts.push(new Point());
			}
			
			resetCorners();
			
			super();
		}
		
		public function get corners():Vector.<Point> {
			updateCornerPts();
			return _cornerPts;
		}
		
		public function dragCorner(num:uint, newPos:Point):void {
			updateCornerPts();
			
			var pt:Point = globalToLocal(_cornerPts[num]);
			newPos = globalToLocal(newPos);
			
			var angleOrig:Number = MathAgj.cartesianToRadians(pt.x, pt.y);
			var angleNew:Number = MathAgj.cartesianToRadians(newPos.x, newPos.y);
			var angleChange:Number = MathAgj.radToDeg(angleOrig - angleNew);
			
			var newRotation:Number = rotation - angleChange;
			if (Input.pressed(Keyboard.SHIFT))
				newRotation = Math.round(newRotation / 45) * 45;
			
			var distOrig:Number = pt.length;
			var distNew:Number = newPos.length;
			var scaleNew:Number = distNew * scaleX / distOrig;
			
			rotation = newRotation;
			scale = scaleNew;
		}
		
		public function resetCorners():void {
			var bounds:Rectangle = getBounds(this);
			
			var corner:Shape = _corners[0];
			corner.x = bounds.left;
			corner.y = bounds.top;
			
			corner = _corners[1];
			corner.x = bounds.right;
			corner.y = bounds.top;
			
			corner = _corners[2];
			corner.x = bounds.right;
			corner.y = bounds.bottom;
			
			corner = _corners[3];
			corner.x = bounds.left;
			corner.y = bounds.bottom;
		}
		
		public function addChildCentered(child:DisplayObject):void {
			var bounds:Rectangle = child.getBounds(child);
			child.x = bounds.width * -0.5 - bounds.x;
			child.y = bounds.height * -0.5 - bounds.y;
			addChild(child);
		}
		
		public function centerRegistrationPoint(keepScreenPosition:Boolean = false):void {
			var bounds:Rectangle = getBounds(this);
			var offX:Number = (bounds.width * -0.5) - bounds.x;
			var offY:Number = (bounds.height * -0.5) - bounds.y;
			var child:DisplayObject;
			for (var i:int = numChildren - 1; i >= 0; i--) {
				child = getChildAt(i);
				child.x += offX;
				child.y += offY;
			}
			
			if (keepScreenPosition) {
				x -= offX;
				y -= offY;
			}
		}
		
		public function get allowsTransformation():Boolean {
			return _allowsTransformation;
		}
		public function set allowsTransformation(value:Boolean):void {
			_allowsTransformation = value;
		}
		
		public function get allowsDrag():Boolean {
			return _allowsDrag;
		}
		public function set allowsDrag(value:Boolean):void {
			_allowsDrag = value;
		}
		
		public function get minScale():Number {
			return _minScale;
		}
		public function set minScale(value:Number):void {
			_minScale = value;
		}
		
		public function get maxScale():Number {
			return _maxScale;
		}
		public function set maxScale(value:Number):void {
			_maxScale = value;
		}
		
		/////
		
		protected function updateCornerPts():void {
			var corner:Shape;
			var pt:Point;
			for (var i:uint = 0; i < 4; i++) {
				corner = _corners[i];
				pt = _cornerPts[i];
				pt.x = corner.x;
				pt.y = corner.y;
				_cornerPts[i] = localToGlobal(pt);
			}
		}
		
		/////
		
		override public function set rotation(value:Number):void {
			super.rotation = value;
			//_cornersContainer.rotation = value;
		}
		
		public function set scale(value:Number):void {
			super.scaleX = super.scaleY = MathAgj.enforceRange(value, _minScale, _maxScale);
			//_cornersContainer.scaleX = _cornersContainer.scaleY = value;
		}
		public function get scale():Number {
			return scaleX;
		}
		
		override public function set x(value:Number):void {
			super.x = value;
		}
		override public function set y(value:Number):void {
			super.y = value;
		}
		
		override public function set scaleX(value:Number):void {
			throw new Error("Transformable: Instead of scaleX and scaleY, please use the scale property.");
		}
		override public function set scaleY(value:Number):void {
			throw new Error("Transformable: Instead of scaleX and scaleY, please use the scale property.");
		}
		override public function set scaleZ(value:Number):void {
			throw new Error("Transformable: This property is not editable.");
		}
		override public function set z(value:Number):void {
			throw new Error("Transformable: This property is not editable.");
		}
		
	}
}