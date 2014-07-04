package cl.agj.extra.save {
	import cl.agj.core.Destroyable;
	
	import flash.net.SharedObject;
	import flash.utils.describeType;
	
	import flashx.textLayout.elements.Configuration;
	
	public class SaveDataManagerSO extends Destroyable implements ISaveDataManager {
		
		protected var _configObject:Object;
		protected var _properties:Vector.<String>;
		protected var _so:SharedObject;
		
		public function SaveDataManagerSO(configObject:Object, properties:Vector.<String>, soName:String, soPath:String = "/") {
			_so = SharedObject.getLocal(soName, soPath);
			_configObject = configObject;
			_properties = properties;
			
			/*
			var description:XML = describeType(configObject);
			
			trace(description.toString());
			
			for each (var prop:XML in description.type.variable) {
				_properties.push({
					name: prop.name,
					type: prop.type
				});
			}
			//*/
		}
		
		/////
		
		public function save():void {
			for each (var prop:String in _properties) {
				setToSO(prop);
			}
			_so.flush();
		}
		
		public function retrieveSavedData():void {
			for each (var prop:String in _properties) {
				getFromSO(prop);
			}
		}
		
		public function deleteSavedData():void {
			_so.clear();
		}
		
		/////
		
		protected function getFromSO(prop:String):void {
			var newValue:Object = _so.data[prop];
			if (newValue != null)
				_configObject[prop] = newValue;
		}
		
		protected function setToSO(prop:String):void {
			_so.data[prop] = _configObject[prop];
		}
		
		/////
		
		override public function destroy():void {
			_so = null;
			super.destroy();
		}
		
	}
}