package com.isartdigital.utils.ui;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.text.Text;
import pixi.interaction.EventTarget;

/**
 * Classe de base des boutons
 * @author Mathieu ANTHOINE
 */
class Button extends StateGraphic
{
	
	private static inline var UP:Int = 0;
	private static inline var OVER:Int = 1;
	private static inline var DOWN:Int = 2;
	
	private var txt:Text;
	
	private var upStyle:TextStyle;
	private var overStyle:TextStyle;
	private var downStyle:TextStyle;
	
	public function new() 
	{
		
		super();
		boxType = BoxType.SELF;
		interactive = true;
		buttonMode = true;
		
		on(MouseEventType.MOUSE_OVER, _mouseOver);
		on(MouseEventType.MOUSE_DOWN, _mouseDown);
		on(MouseEventType.CLICK, _click);
		on(MouseEventType.MOUSE_OUT, _mouseOut);
		on(MouseEventType.MOUSE_UP_OUTSIDE, _mouseOut);

		initStyle();

		txt = new Text("",upStyle);
		txt.anchor.set(0.5, 0.5);
		
		start();
		
	}
	
	private function initStyle ():Void {
		upStyle={ font: "80px Arial", fill: "#000000", align:"center"};
		overStyle={ font: "80px Arial", fill: "#AAAAAA", align:"center"};
		downStyle = { font: "80px Arial", fill: "#FFFFFF", align:"center" };
	}
	
	public function setText(pText:String):Void {
		txt.text=pText;
	}
	public function getText():String{
		return txt.text;
	}
	override private function setModeNormal ():Void {
		setState(DEFAULT_STATE);		
		anim.gotoAndStop(UP);
		addChild(txt);
		super.setModeNormal();
	}
	
	private function _mouseVoid ():Void {}

	private function _click (pEvent:EventTarget): Void {
		anim.gotoAndStop(UP);
		txt.style=upStyle;
	}	
	
	private function _mouseDown (pEvent:EventTarget): Void {
		anim.gotoAndStop(DOWN);
		SoundManager.getSound("click").play();
		txt.style=downStyle;
	}
	
	private function _mouseOver (pEvent:EventTarget): Void {
		anim.gotoAndStop(OVER);
		SoundManager.getSound("hover").play();
		txt.style=overStyle;
	}
	
	private function _mouseOut (pEvent:EventTarget): Void {
		anim.gotoAndStop(UP);
		txt.style=upStyle;
	}
	
	override public function destroy ():Void {
		off(MouseEventType.MOUSE_OVER, _mouseOver);
		off(MouseEventType.MOUSE_DOWN, _mouseDown);
		off(MouseEventType.CLICK, _click);
		off(MouseEventType.MOUSE_OUT, _mouseOut);
		off(MouseEventType.MOUSE_UP_OUTSIDE, _mouseOut);
		super.destroy();
	}
}