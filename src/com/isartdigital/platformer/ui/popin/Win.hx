package com.isartdigital.platformer.ui.popin;

import com.greensock.easing.Bounce;
import com.greensock.easing.Elastic;
import com.greensock.easing.Quad;
import com.greensock.easing.Sine;
import com.greensock.easing.Strong;
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.isartdigital.platformer.game.GameManager;
import com.isartdigital.platformer.game.sprites.Ui;
import com.isartdigital.platformer.ui.screens.buttons.ButtonUi;
import com.isartdigital.platformer.ui.screens.LevelScreen;
import com.isartdigital.platformer.ui.screens.TitleCard;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.localize.LocalizeText;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import js.Browser;
import pixi.core.text.Text;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Eimin
 */
class Win extends Popin 
{
    private var background:Ui;
	private var btnRetry:ButtonUi;
	private var btnBack:ButtonUi;
	private var victoryText:Text;
	private var unlockedText:Text;
	var timeLine:TimelineMax;
	/**
	 * instance unique de la classe Win
	 */
	private static var instance: Win;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Win {
		if (instance == null) instance = new Win();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
		background = new Ui();
		victoryText = new Text(LocalizeText.useLocalizedtext("VICTORY"), { font: "750px Cleopatra", fill: "#FFFFFF", align: "center" } );
	
		btnBack = new ButtonUi("Back");
		btnRetry = new ButtonUi("Retry");
		
		victoryText.anchor.set(0.5, 0.5);
	
		
		switch GameManager.selectedLevel{
			case "Level1":
				background.setModeJump();
				Browser.getLocalStorage().setItem("Jump", "true");
			case "Level2":
				background.setModeShield();
				Browser.getLocalStorage().setItem("Shield", "true");
			case "Level3": 
				background.setModeSuperShoot();
				Browser.getLocalStorage().setItem("Shoot", "true");
		}
		victoryText.position.y = -height;
		background.scale.x = 0;
		background.scale.y = 0;
		
		
		addChild(victoryText);
		addChild(background);
		
		
		TweenMax.to(victoryText, 2, { alpha:0.1, ease:Sine.easeOut });
		TweenMax.to(background.scale, 0.75, { x:0.75, y:0.75, ease:Sine.easeOut, delay:0.5 });	
		TweenMax.to(background, 0.5, { x: -width/6, ease:Sine.easeOut,onComplete:addButton, delay:2.2});
		TweenMax.to(btnBack, 0.25, { alpha:1, ease:Sine.easeOut ,delay:2.7 } );
		TweenMax.to(btnRetry, 0.25, { alpha:1, onComplete: addEvent, ease:Sine.easeOut,delay:2.7 } );
	}
	
	private function addButton():Void{
		btnRetry.x = background.width / 2;
		btnBack.x = btnRetry.x;
		btnRetry.y = -background.height / 3;
		btnBack.y = background.height / 3;
		btnBack.alpha = 0;
		btnRetry.alpha = 0;
		addChild(btnBack);
		addChild(btnRetry);
		
	}
	private function addEvent():Void{
		btnRetry.once(MouseEventType.CLICK,onClick);
		btnRetry.once(TouchEventType.TAP, onClick);
		btnBack.once(MouseEventType.CLICK,onClick);
		btnBack.once(TouchEventType.TAP,onClick);
	}
	
	private function onClick (pEvent:EventTarget): Void {
		var target:Dynamic = pEvent.target;
		SoundManager.getSound("click").play();
	
		TweenMax.to(background, 0.5, {y:2*height, ease:Sine.easeOut});
		TweenMax.to(btnBack, 0.5, { y:2 * height, ease:Sine.easeOut });
	    TweenMax.to(btnRetry, 0.5, { y:2.*height, ease:Sine.easeOut, onComplete:action, onCompleteParams:[target.getName()]});
		
	}
	private function action(pString:String):Void{
		UIManager.getInstance().closeCurrentPopin();
		SaveManager.saveLevel(GameManager.selectedLevel);
		switch pString{
			case "Retry":
                SoundManager.getSound("epic_loop").stop();
				GameManager.getInstance().retry();
			case "Back":
                SoundManager.getSound("epic_loop").stop();
				SoundManager.getSound("ui_loop").play();
				GameManager.getInstance().destroyAll();
				UIManager.getInstance().openScreen(LevelScreen.getInstance());	
		}
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		removeChild(victoryText);
		instance = null;
	}

}