package com.isartdigital.platformer.ui.screens.buttons;
import com.isartdigital.utils.ui.Button;
import js.Browser;
import js.Lib;

/**
 * ...
 * @author Mathieu ANTHOINE
 */
class ButtonOk extends Button
{

	public function new() 
	{
		super();
		setText("OK");
	}
	
	override private function initStyle ():Void {
		upStyle = { font: "240px Impact", fill: "#FF6700", align:"center"};
		overStyle = { font: "240px Impact", fill: "#FF9900", align:"center"};
		downStyle = { font: "240px Impact", fill: "#FF9900", align:"center"};	
	}
	
	
}