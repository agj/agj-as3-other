package cl.agj.extra.media {
	
	import cl.agj.core.TidyListenerRegistrar;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	
	import org.osflash.signals.Signal;
	
	public class CameraManager extends TidyListenerRegistrar {
		
		public var favorSizeOverFrameRate:Boolean;
		
		protected var _cameraReady:Signal;
		protected var _videoReady:Signal;
		
		protected var _isReady:Boolean;
		
		protected var _camera:Camera;
		protected var _video:Video;
		
		protected var _width:uint;
		protected var _height:uint;
		protected var _fps:uint;
		protected var _cameraIndex:int;
		
		public function CameraManager(width:uint, height:uint, fps:uint, cameraIndex:int = -1) {
			_cameraReady = new Signal;
			_videoReady = new Signal;
			
			_width = width;
			_height = height;
			_fps = fps;
			_cameraIndex = cameraIndex;
			
			super();
			
			init();
		}
		
		protected function init():void {
			if (_cameraIndex >= 0)
				_camera = Camera.getCamera(String(_cameraIndex));
			else
				_camera = Camera.getCamera();
			
			if (_camera) {
				_camera.setMode(_width, _height, _fps, favorSizeOverFrameRate);
			}
			
			if (_camera != null) {
				_video = new Video(camera.width, _camera.height);
				_video.attachCamera(camera);
				
				if (_camera.muted == false)
					onCameraReady();
				else
					registerListenerOnce(_camera, StatusEvent.STATUS, onCameraReady);
				
			} else {
				throw new Error("No camera is available.");
			}
		}
		
		/////
		
		protected function onCameraReady(e:StatusEvent = null):void {
			if (_camera.muted == false || e.code == "Camera.Unmuted") {
				_cameraReady.dispatch();
				registerListener(_video, Event.ENTER_FRAME, onVideoEnterFrame);
			} else {
				throw new Error("Camera access not allowed.");
			}
		}
		
		protected function onVideoEnterFrame(e:Event):void {
			if (_video.videoWidth) {
				unregisterAllListeners(null, null, onVideoEnterFrame);
				_isReady = true;
				_videoReady.dispatch();
			}
		}
		
		/////
		
		public function get camera():Camera {
			return _camera;
		}
		
		public function get video():Video {
			return _video;
		}
		
		public function get cameraReady():Signal {
			return _cameraReady;
		}
		
		public function get videoReady():Signal {
			return _videoReady;
		}
		
		public function get isReady():Boolean {
			return _isReady;
		}
		
		/////
		
		override public function destroy():void {
			_cameraReady.removeAll();
			_videoReady.removeAll();
			
			_video.attachCamera(null);
			_camera = null;
			
			super.destroy();
		}
		
	}
}