package com.squidzoo.skins
{
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.core.DPIClassification;
	
	import spark.skins.mobile.ActionBarSkin;
	
	import com.squidzoo.styles.GraphicsLib;
	
	
	
	public class CustomActionBarSkin extends ActionBarSkin
	{
		private var graphicsLib:GraphicsLib = new GraphicsLib();
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var chromeColor:uint = getStyle("chromeColor");
			var testCSSProperty:uint = getStyle("testColor");
			trace("testCSSProperty in style1: "+testCSSProperty);
			var backgroundAlphaValue:Number = getStyle("backgroundAlpha");
			
			// border size is twice as big on 320
			var borderSize:int = 1;
			if (applicationDPI == DPIClassification.DPI_320)
				borderSize = 2;
			
			var matrix:Matrix= new Matrix();
			var colors:Array=[0x555555,0x111111];//glow on actionbar
			var alphas:Array=[1,1];
			var ratios:Array=[0,128];
			matrix.createGradientBox(500,200, 2.84, 0, -30);
			graphics.lineStyle();
			graphics.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,matrix,SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, -0.02);
			graphics.drawRect(0, borderSize, unscaledWidth, unscaledHeight - (borderSize * 2));
			graphics.endFill();
		}
	}
}