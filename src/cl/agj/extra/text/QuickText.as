package cl.agj.extra.text {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;

	/**
	 * ...
	 * @author agj
	 */
	public class QuickText {
		
		public static function textFlow(text:String, container:DisplayObjectContainer = null, width:Number = 300, height:Number = 300, format:TextLayoutFormat = null, configuration:Configuration = null):TextFlow {
			var textFlow:TextFlow;
			if (configuration)
				textFlow = new TextFlow(configuration);
			else
				textFlow = new TextFlow;
			if (format)
				textFlow.format = format;
			
			var p:ParagraphElement = new ParagraphElement();
			textFlow.addChild(p);
			
			var span:SpanElement = new SpanElement();
			span.text = text;
			p.addChild(span);
			
			if (container) {
				textFlow.flowComposer.addController(new ContainerController(container as Sprite, width, height));
				textFlow.flowComposer.updateAllControllers();
			}
			
			return textFlow;
		}
		
		public static function getHeight(textFlow:TextFlow):Number {
			return NaN;
		}
		
	}

}