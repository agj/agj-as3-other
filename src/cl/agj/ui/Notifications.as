package cl.agj.ui {
	import cl.agj.core.display.TidyGraphic;
	import cl.agj.extra.text.TextLineFactory;
	
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.engine.TextLine;
	
	import flashx.textLayout.formats.TextLayoutFormat;
	
	/**
	 * Class used to display notifications on-screen.
	 * 
	 * @todo This needs work to make it nicer and general-use.
	 * 
	 * @author agj
	 */
	public class Notifications extends TidyGraphic {
		
		protected var _textLineFactory:TextLineFactory;
		protected var _backgroundColor:uint;
		protected var _currentFlash:Sprite;
		protected var _currentNotification:Sprite;
		protected var _delayed:Vector.<Array>;
		
		public function Notifications(backgroundColor:uint = 0x000000, textFormat:TextLayoutFormat = null) {
			_backgroundColor = backgroundColor;
			
			if (!textFormat) {
				textFormat = new TextLayoutFormat;
				textFormat.fontFamily = "_sans";
				textFormat.fontSize = 20;
				textFormat.color = 0xffffff;
			}
			
			_textLineFactory = new TextLineFactory(textFormat);
			_delayed = new Vector.<Array>;
		}
		
		/**
		 * Shows a notification that automatically hides itself after a few seconds.
		 */
		public function flash(text:String, immediate:Boolean = false):void {
			if (!immediate) {
				delay(flash, text);
				return;
			}
			
			if (!stage) return;
			
			var notification:Sprite = draw(text);
			notification.x = stage.stageWidth / 2 - notification.width / 2;
			
			if (!_currentNotification)
				notification.y = 100;
			else
				notification.y = _currentNotification.y + _currentNotification.height + 30;
			
			addChild(notification);
			TweenLite.to(notification, 1, { alpha: 0, delay: 0.5, onComplete: onDisappeared, onCompleteParams: [notification] } );
			
			removeFlash();
			_currentFlash = notification;
		}
		
		/**
		 * Display a notification text that remains until hideNotification() is called.
		 */
		public function notify(text:String, immediate:Boolean = false):void {
			if (!immediate) {
				delay(notify, text);
				return;
			}
			
			if (!stage) return;
			
			if (_currentNotification && _currentNotification.parent == this) {
				removeChild(_currentNotification);
			}
			removeFlash();
			
			var notification:Sprite = draw(text);
			notification.x = stage.stageWidth / 2 - notification.width / 2;
			notification.y = 100;
			
			addChild(notification);
			_currentNotification = notification;
		}
		
		/**
		 * Hides the currently displayed notification.
		 * 
		 * @param immediate	By default it will wait for the next frame to hide it; pass 'true' to make it immediate.
		 */
		public function hideNotification(immediate:Boolean = false):void {
			if (!immediate) {
				delay(hideNotification);
				return;
			}
			
			if (!_currentNotification || _currentNotification.parent != this) return;
			
			TweenLite.to(_currentNotification, 1, { alpha: 0, onComplete: onDisappeared, onCompleteParams: [_currentNotification] } );
			_currentNotification = null;
		}
		
		/////////////////////////////////
		
		protected function delay(... args):void {
			_delayed.push(args);
			
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME, onFrameJump);
		}
		
		protected function draw(text:String):Sprite {
			_textLineFactory.makeTextLine(text);
			var textLine:TextLine = _textLineFactory.textLine;
			var notification:Sprite = new Sprite;
			
			notification.graphics.beginFill(_backgroundColor, 0.5);
			notification.graphics.drawRoundRect(0, 0, textLine.textWidth + 60, textLine.textHeight + 60, 30, 30);
			notification.graphics.endFill();
			
			textLine.x = 30;
			textLine.y = 30 + textLine.ascent;
			notification.addChild(textLine);
			
			return notification;
		}
		
		protected function removeFlash():void {
			if (_currentFlash) {
				if (_currentFlash.parent == this)
					removeChild(_currentFlash);
				_currentFlash = null;
			}
		}
		
		/////////////////////////////////
		
		protected function onFrameJump(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, onFrameJump);
			var len:int = _delayed.length;
			for (var i:int = 0; i < len; i++) {
				var args:Array;
				if (_delayed[i].length > 1) {
					args = _delayed[0].slice(1);
				} else {
					args = [];
				}
				args.push(true);
				
				_delayed[i][0].apply(this, args);
			}
			_delayed.splice(0, _delayed.length);
		}
		
		protected function onDisappeared(notification:Sprite):void {
			if (_currentNotification == notification)
				_currentNotification = null;
			if (_currentFlash == notification)
				_currentFlash = null;
			if (notification.parent == this)
				removeChild(notification);
		}
		
	}

}