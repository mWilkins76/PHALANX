package com.isartdigital.platformer.ui.popin;

import com.greensock.easing.Sine;
import com.greensock.easing.Strong;
import com.greensock.TweenMax;
import com.isartdigital.platformer.controller.ControllerTouch;
import com.isartdigital.platformer.game.GameManager;
import com.isartdigital.platformer.game.sprites.mobiles.Player;
import com.isartdigital.platformer.game.sprites.Ui;
import com.isartdigital.platformer.ui.screens.buttons.ButtonUi;
import com.isartdigital.platformer.ui.screens.TitleCard;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Popin;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Eimin
 */
class Pause extends Popin 
{
	private var background:Ui;
	/**
	 * instance unique de la classe Pause
	 */
	private static var instance: Pause;
	
	private var btnPlay:ButtonUi;
	private var btnRetry:ButtonUi;
	private var btnBack:ButtonUi;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Pause {
		if (instance == null) instance = new Pause();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
		private function new() 
	{
		super();
		background = new Ui();
		background.setModePause();
		background.scale.x = 0;
		background.scale.y = 0;
		addChild(background);
		var tween:TweenMax = new TweenMax(background.scale, 0.75, { x:1,y:1, onComplete:createButton, ease:Sine.easeOut});
		
	}
	private function createButton():Void{
		btnPlay = new ButtonUi("Play");
		btnBack = new ButtonUi("Back");
		btnRetry = new ButtonUi("Retry");
		btnPlay.x = -background.width;
		
		btnRetry.scale.x = 0;
		btnRetry.scale.y = 0;
		
		btnBack.x = background.width;
		
		
		addChild(btnPlay);
		addChild(btnRetry);
		addChild(btnBack);
		var tweenPlay:TweenMax = new TweenMax(btnPlay, 0.5, { x:((-background.width/2) + btnPlay.width),  ease:Strong.easeOut});
		var tweenBack:TweenMax = new TweenMax(btnBack, 0.5, { x:((background.width / 2 )- btnBack.width), ease:Strong.easeOut});
		var tweenRetry:TweenMax = new TweenMax(btnRetry.scale, 0.5, { x:1,y:1, onComplete:setEvent, ease:Sine.easeOut});
		/*btnPlay.x = (-background.width/2 + btnPlay.width) ;
		btnBack.x = (background.width / 2 - btnPlay.width);*/
		
		
		
		
	}
	private function setEvent():Void{
		
		btnPlay.once(MouseEventType.CLICK,onClick);
		btnPlay.once(TouchEventType.TAP, onClick);
		btnRetry.once(MouseEventType.CLICK,onClick);
		btnRetry.once(TouchEventType.TAP, onClick);
		btnBack.once(MouseEventType.CLICK,onClick);
		btnBack.once(TouchEventType.TAP,onClick);
	}
	private function onClick (pEvent:EventTarget): Void {
		var target:Dynamic = pEvent.target;
		SoundManager.getSound("click").play();
		var tweenBackground:TweenMax = new TweenMax(background, 0.5, {y:height, ease:Sine.easeOut});
		//var tweenBack:TweenMax = new TweenMax(btnBack.scale, 0.75, { x:0, y:0, ease:Sine.easeOut } );
		var tweenBackPos:TweenMax = new TweenMax(btnBack, 0.5, { y:height, ease:Sine.easeOut } );
	
		//var tweenPlay:TweenMax = new TweenMax(btnPlay.scale, 0.75, { x:0, y:0, ease:Sine.easeOut } );
		var tweenPlayPos:TweenMax = new TweenMax(btnPlay, 0.5, { y:height, ease:Sine.easeOut } );
		
		var tweenRetry:TweenMax = new TweenMax(btnRetry, 0.5, { y:height, onComplete:action,onCompleteParams:[target.getName()], ease:Sine.easeOut});
	}
	private function action(pString:String):Void{
		UIManager.getInstance().closeCurrentPopin();
		if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP) ControllerTouch.getInstance().isPause = false;
		switch pString{
			case "Play":
				Main.getInstance().on(EventType.GAME_LOOP, GameManager.getInstance().gameLoop);
			case "Retry":
                SoundManager.getSound("epic_loop").stop();
				GameManager.getInstance().retry();
			case "Back":
                SoundManager.getSound("epic_loop").stop();
				SoundManager.getSound("ui_loop").play();
				GameManager.getInstance().destroyAll();
				UIManager.getInstance().openScreen(TitleCard.getInstance());	
		}
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}