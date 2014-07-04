package cl.agj.extra.interactive {
	import cl.agj.core.display.TidyGraphic;
	import cl.agj.core.utils.ListUtil;
	import cl.agj.core.utils.MathAgj;
	import cl.agj.graphics.Draw;
	import cl.agj.graphics.DrawStyle;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ZoomGrid extends TidyGraphic {
		
		public function ZoomGrid() {
			addChild(_back);
			addChild(_layerItems);
			
			_back.alpha = 0;
			
			enabled = true;
		}
		
		/////
		
		protected var _back:Shape = new Shape;
		protected var _layerItems:Sprite = new Sprite;
		
		protected var _items:Vector.<GridElement>;
		protected var _itemsSorted:Vector.<GridElement>;
		protected var _largestSize:Point;
		protected var _normalScale:Number;
		protected var _normalToFullScale:Number;
		protected var _columns:uint;
		protected var _cellSize:Number;
		protected var _offset:Point = new Point;
		
		protected var _points:Vector.<Point>;
		protected var _points2:Vector.<Point>;
		
		protected var _contents:Vector.<DisplayObject>;
		public function get contents():Vector.<DisplayObject> {
			return _contents.concat();
		}
		
		protected var _enabled:Boolean;
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled(value:Boolean):void {
			if (value !== _enabled) {
				if (value) {
					addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				} else {
					removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
					resetView();
				}
				_enabled = value;
			}
		}
		
		/*
		protected var _maxColumns:uint = 40;
		public function get maxColumns():uint {
			return _maxColumns;
		}
		public function set maxColumns(value:uint):void {
			_maxColumns = value;
			updatePositions();
		}
		//*/
		
		protected var _fullScale:Number = 1;
		public function get fullItemScale():Number {
			return _fullScale;
		}
		public function set fullItemScale(value:Number):void {
			_fullScale = value;
			updatePositions();
		}
		
		public function get displayScale():Number {
			return _normalScale;
		}
		
		protected var _width:Number = 500;
		override public function get width():Number {
			return _width;
		}
		override public function set width(value:Number):void {
			_width = value;
			updatePositions();
		}
		
		protected var _height:Number = 500;
		override public function get height():Number {
			return _height;
		}
		override public function set height(value:Number):void {
			_height = value;
			updatePositions();
		}
		
		protected var _padding:Number = 0.2;
		public function get padding():Number {
			return _padding;
		}
		public function set padding(value:Number):void {
			_padding = MathAgj.enforceRange(value, 0, 1);
			updatePositions();
		}
		
		/////
		
		public function setContents(list:Vector.<DisplayObject>):void {
			_contents = list ? list.concat() : null;
			updateItems();
		}
		
		/////
		
		protected function updateItems():void {
			var item:GridElement, obj:DisplayObject;
			if (_items) {
				for each (item in _items) {
					if (item.graphic.parent === _layerItems)
						_layerItems.removeChild(item.graphic);
				}
			}
			_items = new Vector.<GridElement>;
			_largestSize = new Point;
			
			for (var i:int, len:int = _contents.length; i < len; i++) {
				obj = _contents[i];
				item = new GridElement(obj);
				
				_items.push(item);
				if (_largestSize.x < item.size.width)
					_largestSize.x = item.size.width;
				if (_largestSize.y < item.size.height)
					_largestSize.y = item.size.height;
			}
			_itemsSorted = _items.concat();
			updatePositions();
		}
		
		protected function updatePositions():void {
			if (!_items)
				return;
			
			// Invisible background for clicks.
			var g:Graphics = _back.graphics;
			g.clear();
			Draw.rectangle(g, new DrawStyle(0xff00ff, 1), new Rectangle(0, 0, _width, _height));
			
			var len:int = _items.length;
			
			var results:Vector.<Number> = new Vector.<Number>;
			var test:Function = function (num:Number):int {
				var result:Number = Math.floor(_width / num) * Math.floor(_height / num);
				if (results.length === 2) {
					//if (results[0] === results[1] && (result > results[0] || result === results[0]) && result >= len)
					if ((results[0] === results[1] || results[0] === result) && result >= len)
						return 0;
					results.shift();
				}
				results.push(result);
				return result === len || result === len + 1 ? 0 : result > len ? -1 : 1;
			};
			
			_cellSize = NaN;
			_cellSize = len > 0 ? binarySearch(0, Math.min(_width, _height), test) : NaN;
			
			_points  = new Vector.<Point>(_contents.length, true);
			_points2 = new Vector.<Point>(_contents.length, true);
			
			_columns = Math.floor(_width / _cellSize);
			_offset.x = (_width - _columns * _cellSize) / 2 + _cellSize * 0.5;
			_offset.y = (_height - Math.ceil(_contents.length / _columns) * _cellSize) / 2 + _cellSize * 0.5;
			
			_normalScale = Math.min((_cellSize - _cellSize * _padding) / Math.max(_largestSize.x, _largestSize.y), 1);
			_normalToFullScale = _fullScale / _normalScale;
			
			for (var i:int = 0; i < len; i++) {
				var item:GridElement = _items[i];
				item.scale = _normalScale;
				_layerItems.addChild(item.graphic);
				var pos:Point = new Point(
					(i % _columns) * _cellSize + _offset.x,
					Math.floor(i / _columns) * _cellSize + _offset.y
				);
				_points[i] = pos;
				_points2[i] = pos.clone();
			}
			
			resetView();
		}
		
		protected function resetView():void {
			if (!_items)
				return;
			
			for (var i:int = 0, len:int = _items.length; i < len; i++) {
				var pos:Point = _points[i];
				pos.x = (i % _columns) * _cellSize + _offset.x;
				pos.y = Math.floor(i / _columns) * _cellSize + _offset.y;
				_points2[i].x = pos.x;
				_points2[i].y = pos.y;
				
				var item:GridElement = _items[i];
				item.scale = item.scale = _normalScale;
				item.graphic.x = pos.x;
				item.graphic.y = pos.y;
			}
		}
		
		protected function updateView():void {
			var temp:Vector.<Point> = _points;
			_points = _points2;
			_points2 = temp;
			
			var halfCell:Number = _cellSize / 2;
			var mouse:Point = new Point(mouseX, mouseY);
			var rows:uint = Math.ceil(_items.length / _columns);
			
			var center:Point = new Point;
			var shift:Point = new Point;
			var halfSize:Point = new Point;
			var pt:Point = new Point;
			//var scaleFactor:Number = halfCell * _normalScale * 8;
			var scaleFactor:Number = _normalScale;
			
			_itemsSorted.splice(0, _itemsSorted.length);
			
			for (var i:int = 0, len:int = _items.length; i < len; i++) {
				var cx:int = i % _columns;
				var cy:int = Math.floor(i / _columns);
				center.x = cx * _cellSize + _offset.x;
				center.y = cy * _cellSize + _offset.y;
				
				var current:Point = _points[i];
				var above:Point = cy > 0 ?            ListUtil.get2D(_points, cx, cy-1, _columns) : null;
				var below:Point = cy < rows - 1 ?     ListUtil.get2D(_points, cx, cy+1, _columns) : null;
				var left:Point  = cx > 0 ?            ListUtil.get2D(_points, cx-1, cy, _columns) : null;
				var right:Point = cx < _columns - 1 ? ListUtil.get2D(_points, cx+1, cy, _columns) : null;
				if (above) var itemAbove:GridElement = ListUtil.get2D(_items, cx, cy-1, _columns);
				if (below) var itemBelow:GridElement = ListUtil.get2D(_items, cx, cy+1, _columns);
				if (left)  var itemLeft:GridElement  = ListUtil.get2D(_items, cx-1, cy, _columns);
				if (right) var itemRight:GridElement = ListUtil.get2D(_items, cx+1, cy, _columns);
				
				var limitAbove:Number = above ? above.y + scaleFactor * itemAbove.halfSize.height * getSize(Point.distance(above, mouse)) : NaN;//(cy-1) * _cellSize + _offset.y + scaleFactor * _cellSize * 0.5;
				var limitBelow:Number = below ? below.y - scaleFactor * itemBelow.halfSize.height * getSize(Point.distance(below, mouse)) : NaN;//(cy+1) * _cellSize + _offset.y - scaleFactor * _cellSize * 0.5;
				var limitLeft:Number  = left  ? left.x  + scaleFactor * itemLeft.halfSize.width   * getSize(Point.distance(left,  mouse)) : NaN;//(cx-1) * _cellSize + _offset.x + scaleFactor * _cellSize * 0.5;
				var limitRight:Number = right ? right.x - scaleFactor * itemRight.halfSize.width  * getSize(Point.distance(right, mouse)) : NaN;//(cx+1) * _cellSize + _offset.x - scaleFactor * _cellSize * 0.5;
				
				var newPos:Point = _points2[i];
				newPos.x = limitLeft  && limitRight ? (limitRight - limitLeft ) / 2 + limitLeft  : center.x;
				newPos.y = limitAbove && limitBelow ? (limitBelow - limitAbove) / 2 + limitAbove : center.y;
				
				shift.x = (center.x - newPos.x);
				shift.y = (center.y - newPos.y);
				shift.normalize(shift.length * 0.2);
				
				newPos.offset(shift.x, shift.y);
				
				var item:GridElement = _items[i];
				
				var scale:Number = getSize(Point.distance(center, mouse));
				halfSize.x = item.halfSize.width  * scale * _normalScale;
				halfSize.y = item.halfSize.height * scale * _normalScale;
				newPos.x = MathAgj.enforceRange(newPos.x, halfSize.x, _width  - halfSize.x);
				newPos.y = MathAgj.enforceRange(newPos.y, halfSize.y, _height - halfSize.y);
				
				item.graphic.x = newPos.x;
				item.graphic.y = newPos.y;
				item.scale = scale * _normalScale;
				
				if (scale > 1)
					_itemsSorted.push(item);
			}
			
			_itemsSorted.sort(sort);
			for (i = 0, len = _itemsSorted.length; i < len; i++) {
				_layerItems.addChild(_itemsSorted[i].graphic);
			}
			
			cx = Math.floor(mouse.x / _cellSize) + _offset.x;
			cy = Math.floor(mouse.y / _cellSize) + _offset.y;
			if (cx >= 0 && cy >= 0) {
				item = ListUtil.get2D(_items, cx, cy, _columns);
				if (item)
					_layerItems.addChild(item.graphic);
			}
		}
		
		protected function getSize(mouseDistance:Number):Number {
			var halfCell:Number = _cellSize * 0.5;
			var distance:Number = Math.max(0, mouseDistance - halfCell) * 0.4 + halfCell;
			return Math.max(Math.min(halfCell / distance, 1) * _normalToFullScale, 1);
			return Math.max(Math.min((_cellSize * 3) / (mouseDistance * 6), 1) * _normalToFullScale, 1);
		}
		
		protected function sort(a:GridElement, b:GridElement):int {
			if (a.scale < b.scale)		return -1;
			if (a.scale > b.scale)		return 1;
			if (a.graphic.y < b.graphic.y)					return -1;
			if (a.graphic.y > b.graphic.y)					return 1;
			return 0;
		}
		
		/**
		 * If a right number is not reached, always favors a lower number.
		 * 
		 * @param fn        Function that returns whether the input value is desired (0), it's too large (-1) or too small (1).
		 */
		protected function binarySearch(min:Number, max:Number, fn:Function):Number {
			/*
			if (min === max)
				return min;
			//*/
			
			var best:Number = NaN;
			var count:int = 200;
			while (min !== max) {
				var mid:Number = (max - min) * 0.5 + min;
				var result:int = fn(mid);
				if (result === 0)
					return mid;
				
				if (result < 0)
					min = mid;
				else
					max = mid;
				
				if (isNaN(best) || (result < 0 && mid < best))
					best = mid;
				--count;
				if (count <= 0) {
					return best;
				}
			}
			
			return min;
			
			/*
			var result:int = fn(mid);
			if (result === 0)
				return mid;
			if (result < 0)
				return binarySearch(mid, max, fn);
			return binarySearch(min, mid, fn);
			//*/
		}
		
		/////
		
		protected function onMouseMove(e:MouseEvent):void {
			updateView();
		}
		
		protected function onMouseOut(e:MouseEvent):void {
			resetView();
		}
		
		protected function onEnterFrame(e:Event):void {
			updateView();
		}
		
	}
}