package cl.agj.graphics.brush.vo {
	import cl.agj.graphics.DrawStyle;
	
	import flash.display.CapsStyle;
	
	public class StrokeStyle {
		
		public var drawStyle:DrawStyle;
		
		/** The higher this number, the smoother the line weight shifts, but it adjusts less quickly to movement speed. */
		public var smoothingSamples:uint = 5;
		/** This value is multiplied with 'weight' to obtain the maximum possible weight. */
		public var peakWeightFactor:Number = 1.5;
		/** The lower this number is, the higher the weight variation depending on speed. */
		public var weightStability:Number = 0.5;
		
		public function StrokeStyle(drawStyle:DrawStyle = null, smoothingSamples:uint = 5, peakWeightFactor:Number = 1.5, weightStability:Number = 0.5) {
			this.drawStyle = drawStyle ||= DrawStyle.makeLineStyle(0x000000, 3, 1, CapsStyle.ROUND);
			this.smoothingSamples = smoothingSamples;
			this.peakWeightFactor = peakWeightFactor;
			this.weightStability = weightStability;
		}
		
	}
}