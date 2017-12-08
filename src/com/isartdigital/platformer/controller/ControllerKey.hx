package com.isartdigital.platformer.controller;
import com.isartdigital.utils.events.KeyboardEventType;
import com.isartdigital.utils.ui.Keyboard;
import js.Browser;
import js.html.KeyboardEvent;

	
/**
 * ...
 * @author dachicourt jordan
 */
class ControllerKey extends Controller 
{
	
	/**
	 * instance unique de la classe ControllerKey
	 */
	private static var instance: ControllerKey;
	var inputs : Map<Int,Bool>;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ControllerKey {
		if (instance == null) instance = new ControllerKey();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		Browser.window.addEventListener(KeyboardEventType.KEY_DOWN, keyDown);
		Browser.window.addEventListener(KeyboardEventType.KEY_UP, keyUp);
		inputs = new  Map<Int,Bool>();
	}
	public function keyDown(pEvent:KeyboardEvent):Void{
		inputs.set(pEvent.keyCode, true);
	}
	
	public function keyUp(pEvent:KeyboardEvent):Void{
		inputs.set(pEvent.keyCode, false);
	}
	
	override  private function get_left():Bool 
	{
		return inputs.get(Keyboard.LEFT);
	}
	
	override  private function get_right():Bool 
	{
		return inputs.get(Keyboard.RIGHT);
	}
	
	override  private function get_jump():Bool 
	{
		return inputs.get(Keyboard.UP);
	}
	
	override  private function get_fire():Bool 
	{
		return inputs.get(Keyboard.SPACE);
	}
	
	override  private function get_pause():Bool 
	{
		return inputs.get(Keyboard.ESCAPE);
	}
	
	override private function get_god():Bool 
	{
		return inputs.get(Keyboard.G);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Browser.window.removeEventListener(KeyboardEventType.KEY_DOWN, keyDown);
		Browser.window.removeEventListener(KeyboardEventType.KEY_UP, keyUp);
		instance = null;
	}
}