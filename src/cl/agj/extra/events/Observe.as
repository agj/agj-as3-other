package cl.agj.extra.events {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import raix.reactive.IObservable;
	import raix.reactive.Observable;

	public class Observe {
		
		/**
		 * The stream is the string "drag" when a drag was started, or "click" when it was clicked.
		 */
		static public function clickOrDrag(target:InteractiveObject):IObservable {
			return Observable.fromEvent(target, MouseEvent.MOUSE_DOWN).mapMany( function ():IObservable {
				var stage:Stage = target.stage;
				var start:Point = new Point(stage.mouseX, stage.mouseY);
				var now:Point = new Point;
				return Observable.amb([
					Observable.fromEvent(stage, MouseEvent.MOUSE_MOVE).filter( function ():Boolean {
						now.setTo(stage.mouseX, stage.mouseY);
						return Point.distance(start, now) > 10;
					}).map(RxMap.value("drag")),
					Observable.fromEvent(target.stage, MouseEvent.MOUSE_UP).map(RxMap.value("click"))
				]).take(1);
			});
		}
		
		/**
		 * When the mouse enters the visible stage, the stream is "true"; when it exits, the stream becomes "false".
		 */
		static public function mouseEnterExit(stage:Stage):IObservable {
			return Observable.fromEvent(stage, MouseEvent.MOUSE_MOVE).map(RxMap.value(true))
				.merge(Observable.fromEvent(stage, Event.MOUSE_LEAVE).map(RxMap.value(false)))
				.distinctUntilChanged();
		}
		
		/**
		 * The stream is "true" when the mouse is over the target, and "false" when not.
		 */
		static public function mouseOverOut(target:InteractiveObject):IObservable {
			return Observable.fromEvent(target, MouseEvent.ROLL_OVER)
				.merge(Observable.fromEvent(target, MouseEvent.ROLL_OUT))
				.map( function (e:MouseEvent):Boolean {
					return e.type === MouseEvent.ROLL_OVER;
				});
		}
		
		static public function clickOutside(target:InteractiveObject):IObservable {
			if (!target || !target.stage)
				throw new ArgumentError("target must not be null, and it must be within the stage.");
			
			return Observable.fromEvent(target.stage, MouseEvent.MOUSE_DOWN)
				.filter( function (e:MouseEvent):Boolean {
					var t:InteractiveObject = e.target;
					while (t) {
						if (t === target)
							return false;
						t = t.parent;
					}
					return true;
				} );
		}
		
		/**
		 * The stream is "true" when the target was clicked, and "false" when something else was clicked.
		 */
		static public function clickInOut(target:InteractiveObject):IObservable {
			if (!target || !target.stage)
				throw new ArgumentError("target must not be null, and it must be within the stage.");
			
			var clicDentro:IObservable = Observable.fromEvent(target, MouseEvent.CLICK);
			var clicFuera:IObservable = Observe.clickOutside(target);
			
			return clicDentro.map(RxMap.value(true)).merge(clicFuera.map(RxMap.value(false)));
		}
		
	}
}