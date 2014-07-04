package cl.agj.engine {
	
	import cl.agj.core.Destroyable;
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.utils.ListUtil;
	
	import flash.events.KeyboardEvent;
	
	public class Cog extends Destroyable implements ICog {
		
		protected var _lastTick:uint;
		protected var _localTime:uint;
		
		protected var _subCogs:Vector.<ICog>;
		
		public function Cog() {
			_subCogs = new Vector.<ICog>;
			super();
		}
		
		/////////
		
		protected function update(elapsed:uint):void {
			
		}
		
		protected function addSubCog(cog:ICog):void {
			_subCogs.push(cog);
		}
		
		protected function removeSubCog(cog:ICog):void {
			ListUtil.remove(_subCogs, cog);
		}
		
		////////
		
		public function onEnterFrame(elapsed:uint):void {
			if (_isDestroyed)
				return;
			_lastTick = _localTime;
			_localTime += elapsed;
			update(elapsed);
			
			for each (var cog:ICog in _subCogs) {
				cog.onEnterFrame(elapsed);
			}
		}
		
		public function onKeyDown(key:uint, char:String, e:KeyboardEvent):void {
			for each (var cog:ICog in _subCogs) {
				cog.onKeyDown(key, char, e);
			}
		}
		
		public function onKeyUp(key:uint, char:String, e:KeyboardEvent):void {
			for each (var cog:ICog in _subCogs) {
				cog.onKeyUp(key, char, e);
			}
		}
		
		/////
		
		override public function destroy():void {
			super.destroy();
			Destroyer.destroy([
				_subCogs
			]);
		}
		
	}
}