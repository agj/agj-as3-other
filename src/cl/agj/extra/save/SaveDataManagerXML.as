package cl.agj.extra.save {
	import cl.agj.core.Destroyable;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class SaveDataManagerXML extends Destroyable implements ISaveDataManager {
		
		protected var _configClass:Class;
		protected var _properties:Vector.<String>;
		protected var _file:File;
		
		public function SaveDataManagerXML(configClass:Class, properties:Vector.<String>, file:File) {
			_configClass = configClass;
			_properties = properties;
			_file = file;
		}
		
		/////
		
		public function save():void {
			var xml:XML = getXMLFromConfig();
			var fs:FileStream = new FileStream;
			fs.open(_file, FileMode.WRITE);
			fs.writeUTF(getXMLFromConfig().toXMLString());
			fs.close();
		}
		
		public function retrieveSavedData():void {
			if (_file.exists) {
				var fs:FileStream = new FileStream;
				fs.open(_file, FileMode.READ);
				parseXML(new XML(fs.readUTF()));
				fs.close();
			}
		}
		
		public function deleteSavedData():void {
			if (_file.exists) {
				_file.deleteFile();
			}
		}
		
		/////
		
		protected function parseXML(xml:XML):void {
			for each (var prop:String in _properties) {
				getFromXML(xml, prop);
			}
		}
		
		protected function getXMLFromConfig():XML {
			var xml:XML = <config></config>;
			for each (var prop:String in _properties) {
				setToXML(xml, prop);
			}
			return xml;
		}
		
		protected function getFromXML(xml:XML, prop:String):void {
			var type:Class = Class(getDefinitionByName(getQualifiedClassName(_configClass[prop])));
			
			var newValue:String = xml[prop].@value;
			if (newValue != "" && newValue != null) {
				if (type == Boolean)
					_configClass[prop] = (newValue == "true");
				else
					_configClass[prop] = type(newValue);
			}
		}
		
		protected function setToXML(xml:XML, prop:String):void {
			var node:XML = new XML("<" + prop + " />");
			node.@value = _configClass[prop];
			xml.appendChild(node);
		}
		
		/////
		
		override public function destroy():void {
			_file = null;
			super.destroy();
		}
		
	}
}