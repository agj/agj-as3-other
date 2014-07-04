package cl.agj.personal {
	import cl.agj.core.preloader.AbstractPreloader;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	
	/**
	 * This is a simple but ready-to-use and nice-looking preloader.
	 * @author agj
	 */
	public class RectanglePreloader extends AbstractPreloader {
		
		protected var _fillColor:uint = 0x000000;
		protected var _voidColor:uint = 0xfefefe;
		protected var _backColor:uint = 0xf0f0f0;
		protected var _rect:Rectangle;
		
		protected var _graphic:Shape = new Shape;
		protected var _background:Shape = new Shape;
		
		protected var _lastBytes:int;
		
		public function RectanglePreloader(mainClassName:String = "Main", rectangle:Rectangle = null) {
			_rect = rectangle ||= new Rectangle(0, 0, 50, 50);
			
			addChild(_background);
			addChild(_graphic);
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			this.contextMenu = cm;
			
			super();
			_mainClassName = mainClassName;
		}
		
		override protected function init(e:Event = null):void {
			super.init(e);
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			updatePositions();
		}
		
		protected function updatePositions():void {
			_rect.x = Math.floor(stage.stageWidth / 2 - _rect.width / 2);
			_rect.y = Math.floor(stage.stageHeight / 2 - _rect.height / 2);
			
			_background.graphics.clear();
			_background.graphics.beginFill(_backColor);
			_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_background.graphics.endFill();
		}
		
		override protected function onProgress():void {
			drawProgress(_progress);
		}
		
		protected function drawProgress(progress:Number):void {
			var g:Graphics = _graphic.graphics;
			g.clear();
			
			var distance:Number = (_rect.width + _rect.height) * progress;
			
			// Void.
			g.beginFill(_voidColor);
			g.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
			g.endFill();
			
			// Fill.
			g.beginFill(_fillColor);
			g.moveTo(_rect.x, _rect.bottom);
			g.lineTo(_rect.x, _rect.bottom - Math.min(distance, _rect.height));
			if (distance > _rect.height) {
				g.lineTo(_rect.x + distance - _rect.height, _rect.y);
			}
			if (distance > _rect.width) {
				g.lineTo(_rect.right, _rect.bottom - (distance - _rect.width));
			}
			g.lineTo(_rect.x + Math.min(distance, _rect.width), _rect.bottom);
			g.lineTo(_rect.x, _rect.bottom);
			g.endFill();
		}
		
		override protected function onLoaded():void {
			stage.removeEventListener(Event.RESIZE, onResize);
			
			_graphic.graphics.clear();
			removeChild(_graphic);
			removeChild(_background);
			
			super.onLoaded();
		}
		
		protected function onResize(e:Event):void {
			updatePositions();
		}
		
	}

}