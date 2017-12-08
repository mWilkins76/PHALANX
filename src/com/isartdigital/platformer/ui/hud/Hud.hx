package com.isartdigital.platformer.ui.hud;

import com.isartdigital.platformer.game.LevelDesignManager;
import com.isartdigital.platformer.game.sprites.mobiles.Player;
import com.isartdigital.platformer.game.sprites.Ui;
import com.isartdigital.platformer.ui.screens.buttons.ButtonAction;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPosition;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

/**
 * Classe en charge de gérer les informations du Hud
 * @author Mathieu ANTHOINE
 */
class Hud extends Screen 
{
	
	/**
	 * instance unique de la classe Hud
	 */
	private static var instance: Hud;
	
	private var hudTopLeft:Container;
	private var hudTopRight:Container;
	private var hudBottomLeft:Container;
	private var hudBottomRight:Container;
	private var btnleft:ButtonAction;
	private var btnRight:ButtonAction;
	private var btnJump:ButtonAction;
	private var btnFire:ButtonAction;
	private var btnPause:ButtonAction;
	private var collectable:Ui;
	public var ScoreText:Text;
	
	

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}	
	
	public function new() 
	{
		super();
		_modal = false;
		hudTopLeft = new Container();
		collectable = new Ui();
		ScoreText = new Text("" + Player.getInstance().actualScore+"/"+LevelDesignManager.totalCollectable,{ font: "80px Cleopatra", fill: "#FFFFFF", align: "left" });
			
		collectable.setModeCollectable();
		collectable.scale.set(0.75, 0.75);
		collectable.alpha = 0.75;
			
		ScoreText.position.set(collectable.x + collectable.width + ScoreText.width / 2, -height + ScoreText.height / 2);
		
		hudTopLeft.addChild(collectable);
		hudTopLeft.addChild(ScoreText);
			
		addChild(hudTopLeft);
		positionables.push( { item:hudTopLeft, align:UIPosition.TOP_LEFT, offsetX:0, offsetY:0 } );
		if(DeviceCapabilities.system!=DeviceCapabilities.SYSTEM_DESKTOP){
			hudBottomLeft = new Container();
			hudBottomRight = new Container();
			hudTopRight = new Container();
			
			btnleft = new ButtonAction("Left");
			btnRight = new ButtonAction("Right");
			btnJump = new ButtonAction("Jump");
			btnFire = new ButtonAction("Fire");
			btnPause = new ButtonAction("Pause");
			
			
			btnleft.position.set( collectable.x+btnleft.width/2, -220);
			btnRight.position.set(btnleft.x + btnRight.width, -220);
			hudBottomLeft.addChild(btnleft);
			hudBottomLeft.addChild(btnRight);
			
			btnJump.position.set(-collectable.x - btnJump.width / 2, -220);
			btnFire.position.set(btnJump.x - btnFire.width, -220);
			hudBottomRight.addChild(btnJump);
			hudBottomRight.addChild(btnFire);
			
			btnPause.position.set(-collectable.x - btnPause.width/ 2, 220);
			hudTopRight.addChild(btnPause);
			
			
			addChild(hudBottomRight);
			addChild(hudBottomLeft);
			addChild(hudTopRight);
			positionables.push( { item:hudBottomLeft, align:UIPosition.BOTTOM_LEFT, offsetX:0, offsetY:0 } );
			positionables.push( { item:hudBottomRight, align:UIPosition.BOTTOM_RIGHT, offsetX:0, offsetY:0 } );
			positionables.push( { item:hudTopRight, align:UIPosition.TOP_RIGHT, offsetX:0, offsetY:0 } );
		}
		
		/*hudTopLeft = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "HudLeft.png")));
		
		hudBottomLeft = new Container();
			
		// affichage de textes utilisant des polices de caractères chargées
		var lTxt:Text = new Text((DeviceCapabilities.system==DeviceCapabilities.SYSTEM_DESKTOP ? "Click" : "Tap" )+ " to move", { font: "80px MyFont", fill: "#FFFFFF", align: "left" } );
		lTxt.position.set(20, -220);
		hudBottomLeft.addChild(lTxt);
		
		var lTxt2:Text = new Text("or use cheat panel", { font: "100px MyOtherFont", fill: "#000000", align: "left" } );
		lTxt2.position.set(20, -120);
		hudBottomLeft.addChild(lTxt2);		
		
		addChild(hudTopLeft);
		addChild(hudBottomLeft);

		positionables.push({ item:hudTopLeft, align:UIPosition.TOP_LEFT, offsetX:0, offsetY:0});
		positionables.push({ item:hudBottomLeft, align:UIPosition.BOTTOM_LEFT, offsetX:0, offsetY:0});*/
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		
		ScoreText.parent.removeChild(ScoreText);
		instance = null;
		super.destroy();
	}

}