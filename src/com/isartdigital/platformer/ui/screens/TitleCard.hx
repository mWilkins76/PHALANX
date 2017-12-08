package com.isartdigital.platformer.ui.screens;

import com.greensock.easing.Back;
import com.greensock.easing.Expo;
import com.greensock.easing.Linear;
import com.greensock.easing.Power4;
import com.greensock.easing.Sine;
import com.greensock.easing.SlowMo;
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.isartdigital.platformer.game.GameManager;
import com.isartdigital.platformer.game.sprites.Ui;
import com.isartdigital.platformer.ui.popin.Confirm;
import com.isartdigital.platformer.ui.screens.buttons.ButtonOk;
import com.isartdigital.platformer.ui.screens.buttons.ButtonUi;
import com.isartdigital.platformer.ui.UIManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import js.Browser;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * Exemple de classe héritant de Screen
 * @author Mathieu ANTHOINE
 */
class TitleCard extends Screen 
{
	private var background:Ui;
	
	/**
	 * instance unique de la classe TitleCard
	 */
	private static var instance: TitleCard;
	
	//boutons;
	private var btnCredits:ButtonUi;
	private var btnPlay:ButtonUi;
	
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TitleCard {
		if (instance == null) instance = new TitleCard();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new() 
	{
		super();
		
		//creation du Background et affichage de celui-ci
		background = new Ui();
		background.setModeTitleCard();
		
		addChild(background);
		
		//creation des boutons du titlecard
		btnCredits = new ButtonUi("Credit");
		btnPlay = new ButtonUi("Play");
		
		
		//definition des position des boutons sur la Titlecard
		
		
		btnCredits.y = background.height/4;
		btnCredits.scale.set(0,0);
		btnPlay.scale.set(0, 0);
	
		//Affichage des Bouton
		background.addChild(btnPlay);
		background.addChild(btnCredits);
		
		var timeline:TimelineMax = new TimelineMax( { onComplete:addListen } );
		
		timeline.add(TweenMax.to(btnPlay.scale, 2, { x:1.2, y:1.2, ease:Power4.easeOut} ));
		timeline.add(TweenMax.to(btnCredits.scale, 1, { x:0.8, y:0.8, ease:Power4.easeOut, delay: -1 } ));
		
		timeline.play();
		//Clear et affiche le Local Storages /!\ CLEAR LE LOCAL STRAGE AVANT LA MISE SUR SVN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//Browser.getLocalStorage().clear();
		
	}
	private function addListen():Void {
	//Association d'evenement a chacun des boutons	
		btnCredits.once(MouseEventType.CLICK,onClick);
		btnCredits.once(TouchEventType.TAP, onClick);
		btnPlay.once(MouseEventType.CLICK,onClickPlay);
		btnPlay.once(TouchEventType.TAP, onClickPlay);
	}
	/**
	 * ouvre la page de credits 
	 */
	private function onClick (pEvent:EventTarget): Void {
		
		UIManager.getInstance().openScreen(Credits.getInstance());
	}
	/**
	 * ouvre la page de selection des levels
	 */
	private function onClickPlay(pEvent:EventTarget):Void{
		
		UIManager.getInstance().openScreen(LevelScreen.getInstance());
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}