package cl.agj.tedio {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class TdPage extends EventDispatcher {
		
		public function TdPage() {
			_localVars = new TdVariables;
			if (!globalVars)
				globalVars = new TdVariables;
		}
		
		////////////////////
		
		private var _instructions:Vector.<Function>;
		private var _currentInstruction:uint;
		
		public function start():void {
			step();
		}
		
		protected function end():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function step():void {
			_commandsExecuted = false;
			_instructions[_currentInstruction]();
			if (!_commandsExecuted) {
				_currentInstruction++;
				if (_currentInstruction >= _instructions.length)
					end();
				else
					step();
			}
		}
		
		protected function addInstructions(... functions):void {
			if (_instructions)
				_instructions = Vector.<Function>(functions);
			else
				_instructions = _instructions.concat(functions);
		}
		
		////////////////////
		
		protected function say(charOrText:String, text:String = null):void {
			if (!check("")) return;
			trace("!", charOrText, text);
		}
		
		protected function choice(text:String, func:Function):void {
			if (!check("")) return;
			trace("?", text, func);
		}
		
		////////////////////
		
		private static var globalVars:TdVariables;
		private var _localVars:TdVariables;
		
		protected function v(name:String):Object {
			if (!check("")) return null;
			if (_localVars.hasVar(name))
				return _localVars.getVar(name);
			else
				return globalVars.getVar(name);
		}
		
		protected function define(varName:String, initialValue:Object = undefined, type:Class = null):void {
			if (!check("")) return;
			globalVars.addVar(varName, initialValue, type);
		}
		
		protected function defineLocal(varName:String, initialValue:Object = undefined, type:Class = null):void {
			if (!check("")) return;
			_localVars.addVar(varName, initialValue, type);
		}
		
		protected function set(name:String, value:Object):void {
			if (!check("")) return;
			if (_localVars[name] !== null)
				_localVars[name] = value;
			else if (TdPage.globalVars[name] !== null)
				TdPage.globalVars[name] = value;
		}
		
		////////////////////
		
		private var _currentLine:int;
		private var _lineCount:int;
		private var _lastCheckType:String;
		private var _commandsExecuted:Boolean;
		
		private static const TYPE_SAY:String = "typeSay";
		private static const TYPE_CHOICE:String = "typeChoice";
		private static const TYPE_VAR:String = "typeVar";
		
		private function check(type:String):Boolean {
			if (false)
				_lineCount++;
			_lastCheckType = type;
			if (_lineCount == _currentLine) {
				_commandsExecuted = true;
				return true;
			}
			return false;
		}
		
	}
}