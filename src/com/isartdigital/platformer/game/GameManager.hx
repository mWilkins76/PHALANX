package com.isartdigital.platformer.game;

import com.isartdigital.platformer.controller.ControllerTouch;
import com.isartdigital.platformer.game.LevelDesignManager;
import com.isartdigital.platformer.game.sprites.LevelObject;
import com.isartdigital.platformer.game.sprites.Mobile;
import com.isartdigital.platformer.game.sprites.mobiles.capacities.Shield;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.Enemy;
import com.isartdigital.platformer.game.sprites.mobiles.Player;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.Charge;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.Shoot;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.platformer.game.sprites.planes.PlaneManager;
import com.isartdigital.platformer.game.sprites.planes.ScrollingPlane;
import com.isartdigital.platformer.game.sprites.stationaries.Checkpoint;
import com.isartdigital.platformer.game.sprites.stationaries.Collectable;
import com.isartdigital.platformer.game.sprites.stationaries.CollectableWin;
import com.isartdigital.platformer.game.sprites.stationaries.KillZone;
import com.isartdigital.platformer.game.sprites.stationaries.Platform;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.platformer.Main;
import com.isartdigital.platformer.ui.popin.Confirm;
import com.isartdigital.platformer.ui.popin.Pause;
import com.isartdigital.platformer.ui.popin.Win;
import com.isartdigital.utils.game.clipping.ClippingManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.sounds.SoundManager;


import com.isartdigital.platformer.ui.CheatPanel;
import com.isartdigital.platformer.ui.UIManager;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Json;
import js.Browser;
import pixi.interaction.EventTarget;
import pixi.interaction.InteractionManager;

/**
 * Manager (Singleton) en charge de gérer le déroulement d'une partie
 * @author Mathieu ANTHOINE
 */
class GameManager
{

	
	/**
	 * instance unique de la classe GameManager
	 */
	private static var instance: GameManager;
	private var backGround:ScrollingPlane;
	public static var selectedLevel:String;
	
	
	///CAPACITES///
	public static var doubleJump:Bool = false;
	public static var shield:Bool = true;
	public static var superShoot:Bool = false;
	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GameManager {
		if (instance == null) instance = new GameManager();
		return instance;
	}
	
	private function new() {
		
	}
	
	public function start (): Void {
		
		doubleJump = (Browser.getLocalStorage().getItem("Jump") != null);
		shield = (Browser.getLocalStorage().getItem("Shield") != null);
		superShoot = (Browser.getLocalStorage().getItem("Shoot") != null);
		PoolManager.init(GameLoader.getContent("pool.json"));
		selectedLevel = Browser.getLocalStorage().getItem("selectedlevel");
		SaveManager.restoreLevel(selectedLevel);

		
		ClippingManager.init(GameLoader.getContent(selectedLevel + ".json"));
		
		LevelDesignManager.init(GameLoader.getContent(selectedLevel + ".json"));
		PlaneManager.init();
		//LevelDesignManager.initGraphics();
		
		// demande au Manager d'interface de se mettre en mode "jeu"
		UIManager.getInstance().startGame();	
		
		GamePlane.getInstance().start();
		GameStage.getInstance().getGameContainer().addChild(GamePlane.getInstance());
		Camera.getInstance().setTarget(GamePlane.getInstance());
		Camera.getInstance().setPosition();
		
		
		// début de l'initialisation du jeu

		Player.getInstance().alpha = 1;
		ClippingManager.update(DeviceCapabilities.getScreenRect(Camera.getInstance().getTarget()));
		
		//MUSIC
		SoundManager.getSound("ui_loop").stop();
		SoundManager.getSound("epic_loop").play();
		
		//CheatPanel.getInstance().ingame();
		
		CheatPanel.getInstance().setCamera();
		if (DeviceCapabilities.system != DeviceCapabilities.SYSTEM_DESKTOP)ControllerTouch.getInstance().init();
		//ControllerTouch.getInstance().init();
		// enregistre le GameManager en tant qu'écouteur de la gameloop principale
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
		
	}

	/**
	 * boucle de jeu (répétée à la cadence du jeu en fps)
	 */
	public function gameLoop (pEvent:EventTarget): Void {
		// le renderer possède une propriété plugins qui contient une propriété interaction de type InteractionManager
		// les instances d'InteractionManager fournissent un certain nombre d'informations comme les coordonnées globales de la souris
		if(Player.getInstance().controller.pause){
			pause();
			return;
		}
		Player.getInstance().doAction();
		GamePlane.getInstance().doAction();	
		Camera.getInstance().move();
		Charge.getInstance().doAction();
		if (Player.getInstance().isShieldOn) Shield.getInstance().doAction();
		LevelObject.executeAction(PlaneManager.list);
		LevelObject.executeAction(Enemy.list);
		LevelObject.executeAction(KillZone.list);
		LevelObject.executeAction(Shoot.list);
		LevelObject.executeAction(Wall.list);
		LevelObject.executeAction(Checkpoint.list);		
		
	}
	public function pause():Void {
		stopGameloop();
		UIManager.getInstance().openPopin(Pause.getInstance());
	}
	public function win():Void {
		SoundManager.getSound("epic_loop").stop();
		SoundManager.getSound("mission_success").play();
		setScore();
		UIManager.getInstance().openPopin(Win.getInstance());
	}
	private function setScore():Void{
		if(Browser.getLocalStorage().getItem(selectedLevel+"score")==null){
			Browser.getLocalStorage().setItem(selectedLevel + "score", "" + Player.getInstance().actualScore);
		}
		else if(Std.parseInt(Browser.getLocalStorage().getItem(selectedLevel + "score"))<Player.getInstance().actualScore){
			Browser.getLocalStorage().setItem(selectedLevel + "score", ""+Player.getInstance().actualScore);
		}
		
	}
	public function retry():Void{
		destroyAll();
		start();
	}
	
	public function stopGameloop():Void{
		Main.getInstance().off(EventType.GAME_LOOP, gameLoop);	
	}
	/**
	 * Gere la destruction de tout les objets level
	 */
	public function destroyAll():Void{
		Player.getInstance().destroy();
		Charge.getInstance().destroy();
		Shield.getInstance().destroy();
		LevelObject.destroyObjects(PlaneManager.list);
		LevelObject.destroyObjects(Enemy.list);
		LevelObject.destroyObjects(KillZone.list);
		LevelObject.destroyObjects(Platform.list);
		LevelObject.destroyObjects(Wall.list);
		LevelObject.destroyObjects(Collectable.list);
		LevelObject.destroyObjects(CollectableWin.list);
		LevelObject.destroyObjects(Checkpoint.list);
		LevelObject.destroyObjects(Checkpoint.activeList);
		LevelObject.destroyObjects(Shoot.list);
		Camera.getInstance().destroy();
		GamePlane.getInstance().destroy();
	    UIManager.getInstance().closeHud();
		PoolManager.clear();
		SaveManager.finalClear();
		
		
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		Main.getInstance().off(EventType.GAME_LOOP,gameLoop);
		instance = null;
	}

}