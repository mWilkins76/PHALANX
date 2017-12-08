package com.isartdigital.platformer.ui.screens.buttons;
import com.isartdigital.utils.ui.Button;
import js.Browser;
import js.Lib;
/**
 * ...
 * @author dachicourt jordan
 */
class ButtonUi extends Button
{
	//Nom du bouton
	private var myName:String;

	public function new(pName:String) 
	{
		assetName = "Button" + pName;
		super();
		//association d'un nom (utilisé pour la sauvegarde de position)
		setName(pName);
	}
	
	/**
	 * Permet d'associer un nom a une instance
	 * @author Marc-Olivier FALLA
	 * @param pName String représentant le nom de l'instance et le no dans la sauvegarde
	 */
	private function setName(pName:String):Void{
		myName = pName;
	}
	
	/**
	 * Permet d'obtenir le nom de l'objet sans la posibilité de le changer
	 * @author Marc-Olivier FALLA
	 * @return myName le Nom de l'instance une string
	 */
	public function getName():String{
		return myName;
	}
	override private function initStyle ():Void {
		upStyle = { font: "100px Cleopatra", fill: "#FFFFFF", align:"center"};
		overStyle = { font: "100px Cleopatra", fill: "#FFFFFF", align:"center"};
		downStyle = { font: "100px Cleopatra", fill: "#FFFFFF", align:"center"};	
	}
	
}