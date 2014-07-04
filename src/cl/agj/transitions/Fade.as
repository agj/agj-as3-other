package cl.agj.transitions {
	import cl.agj.graphics.Draw;
	import cl.agj.graphics.DrawStyle;
	
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author agj
	 */
	public class Fade extends Sprite {
		
		public var color:uint;
		public var duration:uint;
		public var autoRemove:Boolean;
		
		protected var _shape:Shape;
		
		public function Fade(color:uint = 0, duration:uint = 1000, autoRemove:Boolean = true) {
			this.color = color;
			this.duration = duration;
			this.autoRemove = autoRemove;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		
		public function fadeIn():void {
			if (!stage) return;
			
			if (!_shape) {
				_shape = new Shape;
				Draw.rectangle(_shape.graphics, new DrawStyle(color, 1), new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
				addChild(_shape);
			}
			new TweenLite(_shape, duration / 1000, { alpha: 0, onComplete: onFadeIn } );
		}
		
		public function fadeOut():void {
			if (!stage) return;
			
			if (!_shape) {
				_shape = new Shape;
				Draw.rectangle(_shape.graphics, new DrawStyle(color, 1), new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
				addChild(_shape);
				_shape.alpha = 0;
			}
			new TweenLite(_shape, duration / 1000, { alpha: 1, onComplete: onFadeOut } );
		}
		
		////////////////////////////////////////////////////////////////////////////////
		
		protected function onFadeIn():void {
			removeChild(_shape);
			_shape = null;
			if (autoRemove) {
				if (parent)
					parent.removeChild(this);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onFadeOut():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}