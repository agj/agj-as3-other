package cl.agj.extra.utils.appconfig {
	import flash.display.Stage;
	import flash.events.Event;
	
	public function slowDownOnFocusOut(stage:Stage, slowFrameRate:Number = 5):void {
		var currentFrameRate:Number = stage.frameRate;
		stage.addEventListener(Event.DEACTIVATE, function (e:Event):void {
			stage.frameRate = slowFrameRate;
		});
		stage.addEventListener(Event.ACTIVATE, function (e:Event):void {
			stage.frameRate = currentFrameRate;
		});
	}
	
}