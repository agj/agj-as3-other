package cl.agj.transitions {
	
	import cl.agj.graphics.Canvas;
	import cl.agj.graphics.DrawStyle;
	import cl.agj.core.utils.MathAgj;
	
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;
	
	public class DripTransition extends AbstractSeamlessTransition {
		
		protected var _lastTime:uint;
		
		protected var _curtainPositions:Vector.<int>;
		protected var _curtainSizes:Vector.<uint>;
		protected var _curtainAdvancement:Vector.<int>;
		
		public function DripTransition(stageObj:Stage) {
			super(stageObj);
			makeCurtain();
		}
		
		override public function update(elapsed:uint):void {
			super.update(elapsed);
			
			if (_finished) return;
			
			var allDone:Boolean = true;
			var pos:int, size:uint, adv:int, newAdv:int;
			for (var i:int = _curtainPositions.length - 1; i >= 0; i--) {
				adv = _curtainAdvancement[i];
				if (adv < _snapshot.height) {
					pos = _curtainPositions[i];
					size = _curtainSizes[i];
					newAdv = adv + MathAgj.random(30);
					
					_snapshot.drawLine(DrawStyle.makeLineStyle(0x000000, size * 2, 1, CapsStyle.ROUND, JointStyle.MITER).setBlendMode(BlendMode.ERASE), pos, adv, pos, newAdv);
					//_snapshot.drawLine(pos, adv, pos, newAdv, 0x000000, size * 2, 1, CapsStyle.ROUND, "miter", BlendMode.ERASE);
					
					_curtainAdvancement[i] = newAdv;
					
					allDone = false;
				}
			}
			
			if (allDone) {
				onFinished();
			}
		}
		
		override protected function onFinished():void {
			super.onFinished();
		}
		
		protected function makeCurtain():void {
			_curtainSizes = new Vector.<uint>;
			_curtainPositions = new Vector.<int>;
			_curtainAdvancement = new Vector.<int>;
			
			var size:uint, pos:uint = 0;
			while (pos + size < _snapshot.width) {
				size = MathAgj.random(30) + 10;
				_curtainSizes.push(size);
				
				pos += MathAgj.random(size);
				_curtainPositions.push(pos);
				
				_curtainAdvancement.push(0);
			}
		}
		
	}
}