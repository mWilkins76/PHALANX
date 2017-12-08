package com.isartdigital.platformer.controller;
import com.isartdigital.platformer.ui.hud.Hud;
import com.isartdigital.platformer.ui.screens.buttons.ButtonAction;
import com.isartdigital.utils.events.TouchEventType;
import js.html.TouchEvent;

	
/**
 * ...
 * @author Eimin
 */
class ControllerTouch extends Controller 
{
	
	/**
	 * instance unique de la classe ControllerTouch
	 */
	private static var instance: ControllerTouch;
	
	private static var LEFT_STRING:String = "Left";
	private static var RIGHT_STRING:String = "Right";
	private static var JUMP_STRING:String = "Jump";
	private static var SHOOT_STRING:String = "Fire";
	private static var PAUSE_STRING: String = "Pause";
	private var isLeft:Bool = false;
	private var isRight:Bool = false;
	private var isJump:Bool = false;
	private var isShoot:Bool = false;
	public var isPause:Bool = false;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ControllerTouch {
		if (instance == null) instance = new ControllerTouch();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
	}
	public function init():Void {	
		for(button in ButtonAction.list){
			button.on(TouchEventType.TOUCH_START, TouchDown);
			button.on(TouchEventType.TOUCH_END, TouchUp);
		}
	}
	private function TouchDown(pEvent:TouchEvent):Void {
		var target:Dynamic = pEvent.target;
		if (target.getName() == RIGHT_STRING) isRight = true;
		else if (target.getName() == LEFT_STRING) isLeft = true;
		if (target.getName() == JUMP_STRING) isJump = true;
		if (target.getName() == SHOOT_STRING) isShoot = true;
		if (target.getName() == PAUSE_STRING) isPause = true;
		if (target.alpha < 0.3) return;
		target.alpha -= 0.1;
		
		
	}
	private function TouchUp(pEvent:TouchEvent):Void {
		var target:Dynamic = pEvent.target;
		if (target.getName() == RIGHT_STRING) isRight = false;
		else if (target.getName() == LEFT_STRING) isLeft = false;
		if (target.getName() == JUMP_STRING) isJump = false;
		if (target.getName() == SHOOT_STRING) isShoot = false;
		if (target.getName() == PAUSE_STRING) isPause = false;
	}
	override function get_left():Bool 
	{
		return isLeft;
	}
	override function get_right():Bool 
	{
		return isRight;
	}
	override function get_jump():Bool 
	{
		return isJump;
	}
	override function get_fire():Bool 
	{
		return isShoot;
	}
	override function get_pause():Bool 
	{
		return isPause;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		for(button in ButtonAction.list){
			button.off(TouchEventType.TOUCH_START, TouchDown);
			button.off(TouchEventType.TOUCH_END, TouchUp);
		}
		instance = null;
	}
}