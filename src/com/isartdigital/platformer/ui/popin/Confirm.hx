package com.isartdigital.platformer.ui.popin;

import com.isartdigital.platformer.game.GameManager;
import com.isartdigital.platformer.ui.screens.buttons.ButtonOk;
import com.isartdigital.platformer.ui.UIManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * Exemple de classe héritant de Popin
 * @author Mathieu ANTHOINE
 */
class Confirm extends Popin 
{
	
	private var background:Sprite;
	
	/**
	 * instance unique de la classe Confirm
	 */
	private static var instance: Confirm;
	private var btnOk:ButtonOk;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Confirm {
		if (instance == null) instance = new Confirm();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		/*background = new Sprite(Texture.fromImage(Config.url(Config.assetsPath+"Confirm.png")));
		background.anchor.set(0.5, 0.5);
		addChild(background);*/
		
		btnOk = new ButtonOk();
		btnOk.once(MouseEventType.CLICK,onClick);
		btnOk.once(TouchEventType.TAP,onClick);
		addChild(btnOk);
	}
	

	
	private function onClick (pEvent:EventTarget): Void {
		SoundManager.getSound("click").play();
		UIManager.getInstance().closeCurrentPopin();
		Main.getInstance().on(EventType.GAME_LOOP, GameManager.getInstance().gameLoop);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}