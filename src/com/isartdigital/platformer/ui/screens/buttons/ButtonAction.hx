package com.isartdigital.platformer.ui.screens.buttons;

/**
 * ...
 * @author Eimin
 */
class ButtonAction extends ButtonUi
{
	public static var list:Array<ButtonAction> = new Array<ButtonAction>();
	public function new(pName:String) 
	{
		super(pName);
		list.push(this);
		alpha = 0.5;
	}
	
}