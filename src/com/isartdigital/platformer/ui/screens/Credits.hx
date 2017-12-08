package com.isartdigital.platformer.ui.screens;

import com.isartdigital.platformer.game.sprites.Ui;
import com.isartdigital.platformer.ui.screens.buttons.ButtonOk;
import com.isartdigital.platformer.ui.screens.buttons.ButtonUi;
import com.isartdigital.platformer.ui.UIManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Eimin
 */
class Credits extends Screen 
{
	
	/**
	 * instance unique de la classe Credits
	 */
	private static var instance: Credits;
	
	//bouton de retour au menu
	private var btnMenu:ButtonUi;
	
	//background de l'écran de credits
	private var background:Ui;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Credits {
		if (instance == null) instance = new Credits();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
		//creation du Background et affichage de celui-ci
		background =new Ui();
		background.setModeCredits();
		addChild(background);
		
		//creation du bouton de retour au menu  et positionnement
		btnMenu = new ButtonUi("Back");
		btnMenu.y = height / 2 - btnMenu.height;
		
		// associtation d'évement au bouton de retour 
		btnMenu.once(MouseEventType.CLICK,onClick);
		btnMenu.once(TouchEventType.TAP, onClick);
		
		//affichage du bouton de retour au menu
		addChild(btnMenu);
		
	}
	
	/**
	 * Fonction callback du bouton de retour au menu
	 * @author Marc-Olivier FALLA
	 * @param element ou est appliqué l'évènement
	 */
	private function onClick (pEvent:EventTarget): Void {
		SoundManager.getSound("click").play();
		UIManager.getInstance().openScreen(TitleCard.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}