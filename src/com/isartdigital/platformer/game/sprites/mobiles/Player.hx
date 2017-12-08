package com.isartdigital.platformer.game.sprites.mobiles;

import cloudkid.Emitter;
import com.greensock.easing.Sine;
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.greensock.easing.Quart;
import com.isartdigital.platformer.controller.ControllerTouch;
import com.isartdigital.platformer.game.sprites.Mobile;
import com.isartdigital.platformer.controller.Controller;
import com.isartdigital.platformer.controller.ControllerKey;
import com.isartdigital.platformer.game.sprites.mobiles.capacities.Shield;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.Enemy;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.Charge;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.Shoot;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.ShootPlayer;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.platformer.game.sprites.stationaries.Checkpoint;
import com.isartdigital.platformer.game.sprites.stationaries.Collectable;
import com.isartdigital.platformer.game.sprites.stationaries.CollectableWin;
import com.isartdigital.platformer.game.sprites.stationaries.KillZone;
import com.isartdigital.platformer.game.sprites.stationaries.Platform;
import com.isartdigital.platformer.game.sprites.Stationary;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.platformer.ui.hud.Hud;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.game.clipping.ClippingManager;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.SaveManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Circle;
import pixi.filters.color.ColorMatrixFilter;
import cloudkid.Particle;


/**
 * Classe gerant les comportement, les animations, et la physique du player
 * 
 * @author dachicourt jordan, wilkins michael, falla marc olivier
 */
class Player extends Mobile
{

	private static var instance:Player;
	public var controller:Controller;
	
	private var  JUMP_STATE(default, never):String = 'jump';
    private var  FALL_STATE(default, never):String = 'fall';
	private var  JUMPSHOOT_STATE(default, never):String = 'jumpShoot';
    private var  FALLSHOOT_STATE(default, never):String = 'fallShoot';
    private var  RECEPTION_STATE(default, never):String = 'reception';
	private var  RESPAWN_STATE(default, never):String = 'respawn';
	
	private var frictionGround (default, never):Float = 0.75;
	private var accelerationGround(default, never):Float = 8;
	
	private var frictionAir (default, never):Float = 0.95;
	private var accelerationAir(default, never):Float = 8;
	private var gravity (default, never):Float = 3;
	private var impulse (default, never):Float = 12;
	private var doubleImpulse (default, never):Float = 9;
	
	private var impulseDuration(default, never):UInt = 7;
	private var impulseCounter:UInt = 0;
	
	private var  MAX_COUNT_JUMP(default, never):Int = 2;
	private var  CAN_JUMP_TIME(default, never):Int = 3;
	
	private var lastJump:Bool;
	
	private var jumpCounter:Int = 0;
	private var jumpTime:Int = 0;
	
	private var floor:Stationary;
	private var wall: Stationary;
	private var limit:Stationary;
	private var checkPoint:Checkpoint;
	
	private var collision:StateGraphic;
	
	private var collectableMagnet:Array<Collectable>;
	private var collectableGathered:Int = 0;
	
	public var actualScore:Int=0;
	
	private var timeLine:TimelineMax;
	////CAPACITES A DEBLOQUER///
	private var shieldActive:Bool = GameManager.shield;
	private var superShootActive:Bool = GameManager.superShoot;
	private var doubleJumpActive:Bool = GameManager.doubleJump;
	
	private var stopcamCounter:Int = 0;
	private var STOP_CAM(default, never):Int = 20;
	
	
	private var chargeCounter:Int = 0;// counter de la barre d'espace
	private var  BEGIN_CHARGE(default, never):Int = 30; // le moment à partir du quel la charge est visible 
	private var chargeFilter:ColorMatrixFilter = new ColorMatrixFilter();
	
	
	private var weaponPoint:Point;
	private var isFireInputEnabled:Bool = true;
	
	private var  MINIMUM_COLLECTABLES_FOR_SHIELD(default, never):Int = 5;
	public var isShieldOn:Bool = false;
	
	
	private var isBeinghurt:Bool = false;
	
	public var isGod:Bool = false;
	private var isGodPushed:Bool = false;
	
	private var emitter:Emitter;
	
	public static function getInstance (): Player {
		if (instance == null) instance = new Player();
		return instance;
	}
	
	private function new() 
	{
		super("Player");
		boxType = BoxType.SIMPLE;
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP) controller =ControllerKey.getInstance();
		else controller = ControllerTouch.getInstance();
		//controller = ControllerTouch.getInstance();
		
		maxHSpeed = 20;
		
		emitter = new Emitter(this, ["assets/CartoonSmoke.png"],
			{
				"alpha": {
					"start": 0.5,
					"end": 0
				},
				"scale": {
					"start": 0.8,
					"end": 0.2,
					"minimumScaleMultiplier": 0.1
				},
				"color": {
					"start": "#ffffff",
					"end": "#ffffff"
				},
				"speed": {
					"start": 1,
					"end": 0
				},
				"acceleration": {
					"x": 0,
					"y": 10
				},
				"startRotation": {
					"min": -180,
					"max": -170
				},
				"rotationSpeed": {
					"min": 50,
					"max": 50
				},
				"lifetime": {
					"min": 0.8,
					"max": 2
				},
				"blendMode": "normal",
				"frequency": 0.2,
				"emitterLifetime": -1,
				"maxParticles": 3,
				"pos": {
					"x": x,
					"y": y
				},
				"addAtBack": true,
				"spawnType": "rect",
				"spawnRect": {
					"x": -200,
					"y": -50,
					"w": 200,
					"h": 20
				}
			}
		);
		emitter.emit = false;
	}
	
	/**
	 * Demarre l'Etat graphique et initialisation
	 */
	override public function start():Void 
	{
		super.start();
		Camera.getInstance().setFocus(box.getChildByName("mcCamera"));
		firstSavePoint();
		collectableMagnet = new Array<Collectable>();
		
	}
	
	/**
	 * Gere les actions recurrentes du player
	 * @param	pState etat graphique du player
	 */
	private function playerActions(pState:String):Void {
		
		emitter.update(0.1);	
		collisionWithEnnemies();
		collisionWithWin();
		hitCheckpoint();
		getCollectable();
		shieldManagement();
		if (pState != RECEPTION_STATE) shootManagement(pState);
		if (pState == JUMP_STATE) airControl();
		godMode();
		
	}
		
	/* ##### Machine à etats ##### */
	
	//////////////////////NORMAL/////////////////////////////
	
	/**
	 * Met l'etat graphique normal et place l'action sur doActionNormal
	 */
	override private function setModeNormal():Void {
		emitter.emit = false;
		Camera.getInstance().resetX();
		jumpCounter = MAX_COUNT_JUMP;
		Camera.getInstance().canMoveY = false;
		super.setModeNormal();
	}
	
	/**
	 * Actions effectué en etat normal
	 */
	override private function doActionNormal():Void 
	{	
		
		playerActions(WAIT_STATE);
		if(Camera.getInstance().canMoveX)stopCam();
		if (canFall()) setModeFall();
		else if (canJump()) setModeJump();
		else if(canLeft() || canRight())
			setModeWalk();
			
		
		move();
	}
	
	
	////////////////////////FIRE///////////////////////////
	
	/**
	 * Met l'etat graphique fire selon le l'etat graphique precedent exemple : jump+shoot
	 */
	override function setModeFire(pState:String):Void 
	{
		super.setModeFire(pState);
		
		if (pState == JUMP_STATE) setState(JUMPSHOOT_STATE);
		else if (pState == FALL_STATE) setState(FALLSHOOT_STATE);
		
		
	}
	
	
	/////////////////////////WALK//////////////////////////
	
	
	/**
	 * Met l'etat graphique walk et place l'action sur doActionWalk
	 */
	private function setModeWalk():Void {
       
		 setState(WALK_STATE, true);
		 emitter.emit = true;
        
		friction.set(frictionGround,0);
		doAction = doActionWalk;
    }
	
	/**
	 * Actions effectué en etat walk
	 */
	override private function doActionWalk():Void 
	{
		
		playerActions(WALK_STATE);
		
		if (anim.currentFrame==7) SoundManager.getSound("player_footsteps1").play();
		if (anim.currentFrame==18) SoundManager.getSound("player_footsteps2").play();
		
		if (canFall())setModeFall();
		
		if (canJump()) setModeJump();
		
		else if (canLeft()) {
			acceleration.x = -accelerationGround;
			flipLeft();
		}
		else if (canRight()) {
			acceleration.x = accelerationGround;
			flipRight();
		}
		
		move();
		
		if (Math.abs(velocity.x) < 1) setModeNormal();
		
		
		
	}
		
	/////////////////////////JUMP//////////////////////////
	
	/**
	 * Met l'etat graphique Jump et place l'action sur doActionJump
	 */
	private function setModeJump():Void {
		
		SoundManager.getSound("jump").play();
   
        setState(JUMP_STATE);
		emitter.emit = false;
		friction.set(frictionAir, frictionAir);
		impulseCounter = 0;
		jumpTime = 0;
		jumpCounter--;
		if (jumpCounter == 0) Camera.getInstance().canMoveY = true;
        doAction = doActionJump;
    }
   
	/**
	 * Actions effectué en etat jump
	 */
    private function doActionJump():Void
    {
		
		playerActions(JUMP_STATE);
		
		if (impulseCounter++< impulseDuration) acceleration.y = -(jumpCounter>0?impulse:doubleImpulse);
		if (!controller.jump) impulseCounter = impulseDuration;
		if ( doubleJumpActive && canJump() &&jumpTime > CAN_JUMP_TIME && jumpCounter > 0) {
			velocity.y = 0;
			setModeJump(); 
			return;
		}
		
		
		acceleration.y += gravity;
		move();
		jumpTime++;
		
		if (velocity.y > 0) {
			setModeFall();
		}
		else {
			var lCeil:StateGraphic = testPoint(Wall.list, hitTop());
			if (lCeil != null) {
				
					velocity.y = 0;
					y = lCeil.y + lCeil.hitBox.height + hitBox.height;
					setModeFall();
					
			}
		}
		
		
    }
		
	
	//////////////////////////////FALL/////////////////////////////////////
   
	/**
	 * Met l'etat graphique Fall et place l'action sur doActionFall
	 */
    private function setModeFall():Void {
   
        setState(FALL_STATE);
		friction.set(frictionAir, frictionAir);
        doAction = doActionFall;
		emitter.emit = false;
    }
   
	/**
	 * Actions effectué en etat fall
	 */
    private function doActionFall():Void {
		
		collisionWithEnnemies();
		
		if (doubleJumpActive && canJump() && jumpCounter>0) {
			
			velocity.y = 0;
			setModeJump(); 
		}else {
			airControl();
			acceleration.y += gravity;
		
			shootManagement(FALL_STATE);
			getCollectable();
			move();
		}
		
		hitCheckpoint();
		shieldManagement();
		if (hitFloor()) setModeReception();
		emitter.update(0.1);
		

    }
	
	
	//////////////////////////////HURT/////////////////////////////////////	
	
	/**
	 * Met l'etat graphique Hurt et place l'action sur doActionHurt
	 * Il enleve 1 à vie
	 * Restoration de la map sauvegardé
	 */
	override private function setModeHurt():Void {
		
		SoundManager.getSound("player_die").play();
		
		if (life-- > 1) return;
		
		setState(HURT_STATE);
		SaveManager.restoreStatus(SaveManager.LAST);
		doAction = doActionHurt;        
    }
	
	/**
	 * Actions effectué en etat Hurt
	 */
	override private function doActionHurt():Void 
	{
		if (anim.currentFrame == 14) SoundManager.getSound("flesh").play();
		emitter.update(0.1);
		getCollectable();
		acceleration.y += gravity;
		if (canFall())
			move(); 
		else {
			if(isAnimEnd)
				setModeTransitionRespawn();
		}
			
		
	
	}
	
	//////////////////////////////RECEPTION/////////////////////////////////////
	
	/**
	 * Met l'etat graphique Reception et place l'action sur doActionReception
	 */
	private function setModeReception():Void {
		
		SoundManager.getSound("player_reception").play();
		
		emitter.emit = true;
        setState(RECEPTION_STATE);
		velocity.y = 0;
		friction.set(frictionGround, 0);
		jumpCounter = MAX_COUNT_JUMP;
		Camera.getInstance().canMoveY = true;
        doAction = doActionReception;
    }
   
	/**
	 * Actions effectué en etat reception
	 */
    private function doActionReception():Void {
		
		playerActions(RECEPTION_STATE);
		
		if (canJump()) setModeJump();
		else if (controller.left || controller.right) setModeWalk();
		else if (isAnimEnd) setModeNormal();
		
		move();
		
    }
	
	//////////////////////////////RESPAWN/////////////////////////////////////
	
	/**
	 * Gere la transition de respawn, il remove le clipping et le reinitialise puis place l'action sur doActionTransitionRespawn
	 */
	private function setModeTransitionRespawn() {
		doAction = doActionTransitionRespawn;
		refreshScore();
		collectableGathered = 0;
		//on dispose tous ce qu'il y a à l'ecran
		LevelDesignManager.toRemove(ClippingManager.currentDisplay);
		//on reinitialise le clipping
		ClippingManager.init(GameLoader.getContent(GameManager.selectedLevel + ".json"));
		anim.visible = false;
		velocity.set(0, 0);
		acceleration.set(0, 0);
		floor = null;
	}
	
	/**
	 * Gere le respawn du player lui reset sa vie et fait une transition de camera
	 */
	private function doActionTransitionRespawn():Void {
		
		x = Std.parseFloat(Browser.getLocalStorage().getItem("saveX"));
		y = Std.parseFloat(Browser.getLocalStorage().getItem("saveY"));
		life = 1;
		Camera.getInstance().setPosition();
		if(Math.abs(Camera.getInstance().distanceToFocusX) < 30 &&  Math.abs(Camera.getInstance().distanceToFocusY) < 30)
			setModeRespawn();
			
	}
	
	/**
	 * Met l'etat graphique Reception et place l'action sur doActionReception
	 */
	private function setModeRespawn() {
		doAction = doActionRespawn;	
		anim.visible = true;
		SoundManager.getSound("player_respawn").play();
		Camera.getInstance().doShake = true;
		setState(RESPAWN_STATE);

	}
	
	/**
	 * Actions effectué en etat respawn
	 */
	private function doActionRespawn():Void {
		if (isAnimEnd)
			setModeNormal();
	}
	
	/**
	 * 
	 * @return true si en etat de respawn false sinon
	 */
	public function isRespawn():Bool {
		return state == RESPAWN_STATE;
	}
	
	
	
	///////////////////////////////////////////////////////////////////
	
	
	/*##### GOD MODE ######*/
	
	
	/**
	 * controller du god mode
	 */
	private function godMode():Void {
	
		if (controller.god && !isGodPushed) setGod();
		if (!controller.god) isGodPushed = false;
	}
	
	/**
	 * Set le god mode
	 */
	private function setGod():Void {
		
		isGodPushed = true;
		isGod = !isGod;
		if (isGod) {
			
			if (isShieldOn) {
				collectableGathered = 0;
				Shield.getInstance().setModeExplode();
			}
			else beGod();
		}
		else dontBeGod();
	}
	
	/**
	 * Mise en place des capacité du godMode
	 */
	public function beGod():Void {
		
		
		
		SoundManager.getSound("godmode_on").play();
		
		doubleJumpActive = true;
		superShootActive = true;
		shieldActive = false;
		
		////BOUCLIER COSMETIQUE DE ZEUS///
		isShieldOn = true;
		Shield.getInstance().x = x;
		Shield.getInstance().y = y;
		
	}
	
	/**
	 * Desactive les capacité godMode
	 */
	private function dontBeGod():Void {
		
		
		SoundManager.getSound("godmode_off").play();
		
		doubleJumpActive = GameManager.doubleJump;
		superShootActive = GameManager.superShoot;
		shieldActive = GameManager.shield;
		
		life = 1;
		
		isShieldOn = false;
		Shield.getInstance().setModeExplode();
	}
		
	/*##### SHOOT MANAGEMENT ######*/
	
	
	/**
	 * Gere les controller et les actions associé pour le shoot
	 * @param	pCurrentState Etat graphique precedent au shoot
	 */
	private function shootManagement(pCurrentState:String):Void {
	
		if (controller.fire) onFireButtonPress();
		else onFireButtonRelease(pCurrentState);
		
		if (isAnimEnd) setState(pCurrentState, true);
		
		
	}
	
	/**
	 * Gere la charge du super shoot
	 */
	private function onFireButtonPress():Void {
		
		chargeCounter++;
		isFireInputEnabled = false;
		if (superShootActive && chargeCounter > BEGIN_CHARGE) setSuperShootReady();
	}
	
	/**
	 * Au relachement du bouton on appel la gestion des shoot
	 * @param	pCurrentState Etat graphique precedent au shoot
	 */
	private function onFireButtonRelease(pCurrentState:String):Void {
		
		if( !isFireInputEnabled) thePlayerShoots(pCurrentState);
		isFireInputEnabled = true;
		anim.filters = null;
		
	}
	
	/**
	 * Gere le super et le shoot normal et les instancis
	 * @param	pCurrentState Etat graphique precedent au shoot
	 */
	private function thePlayerShoots(pCurrentState:String):Void {
		
		SoundManager.getSound("player_shoot").play();
	
		if (canSuperShoot()) {
			shoot = cast(PoolManager.getFromPool(Shoot.SUPER),Shoot);
			Charge.getInstance().destroy();
		}
		else shoot = cast(PoolManager.getFromPool(Shoot.PLAYER),Shoot);
		
		shoot.init();	
		shoot.position = GamePlane.getInstance().toLocal(weaponOrigin());
		shoot.setAngle(scale.x == 1?0:Math.PI);
		shoot.start();
		parent.addChild(shoot);
		anim.gotoAndPlay(0);
		
		setModeFire(pCurrentState);
			
		chargeCounter = 0;
	}
	
	/**
	 * retourne un booléen
	 * @return true si peut faire le super shoot, false sinon
	 */
	private function canSuperShoot():Bool {
		
		
		if ( anim.filters !=null) return true;
		else return false;
		
	}
	
	/**
	 * Gere l'animation de charge
	 */
	private function setSuperShootReady():Void {
	
		Charge.getInstance().x = x;
		Charge.getInstance().y = y;
		Charge.getInstance().start();
		GamePlane.getInstance().addChild(Charge.getInstance());
		chargeFilter.brightness(2, false);
		anim.filters = [chargeFilter];
		
		
		
	}
	
		
	/*##### SHIELD MANAGEMENT ######*/
	
	/**
	 * Gere les etat du shield
	 */
	private function shieldManagement():Void {
		
		if (!shieldActive) return;
		else{
		
			if (!isShieldOn && collectableGathered >= MINIMUM_COLLECTABLES_FOR_SHIELD) shielding();
			if (isShieldOn && life == 1)shieldExplosion();
		}
	
		
	}
	
	/**
	 * Gere le comportement du shield
	 */
	private function shielding():Void {
		
	
		Shield.getInstance().x = x;
		Shield.getInstance().y = y;
		life++;
		isShieldOn = true;
			
	}
	
	/**
	 * Gere l'explosion du shield
	 */
	private function shieldExplosion():Void {
		
		collectableGathered = 0;
		isShieldOn = false;
		Shield.getInstance().setModeExplode();
		
	}
	
	
	////////////////////////////// COMPORTEMENT PLAYER /////////////////////////////////////
	
	/**
	 * Gere la velocité et stock l'etat de la touche jump pour le canJump
	 */
	override private function move():Void {
		super.move();
		lastJump = controller.jump;
	}
	
	/**
	 * 
	 */
	override function flip():Void 
	{
		Camera.getInstance().resetX();
	}
	
	/**
	 * Gere la disparition des collectables
	 * @param	pCollectable
	 */
	private function removeCollectable(pCollectable:Collectable):Void{
		if (pCollectable != null) {
			pCollectable.switchStatus();
			pCollectable.dispose();
			collectableMagnet.remove(pCollectable);
			if (shieldActive)++collectableGathered;
			refreshScore();
			SoundManager.getSound("collectable").play();
		}
	}
	
	/**
	 * Stop la cam une fois le compteur arriver à la fin.
	 */
	private function stopCam():Void {
		stopcamCounter++;
		if (stopcamCounter > STOP_CAM) {
			Camera.getInstance().canMoveX = false;
			Camera.getInstance().canMoveY = false;
			stopcamCounter = 0;
		}
	}
	
	
	/**
	 * Gere le magnet des collectable
	 */
	private function getCollectable():Void {
		var coll:StateGraphic = hitTestBox(Collectable.list, hitMagnet());
		
		if (coll != null ) {	
			if (!Lambda.has(collectableMagnet,cast(coll, Collectable))){
				collectableMagnet.push(cast(coll, Collectable));
				Collectable.list.remove(cast(coll, Collectable));
				var tween : TweenMax = new TweenMax(coll, 0.5, { x : x + hitCenter().x , y: y + hitCenter().y , onUpdate: updateMagnet, onUpdateParams:["{self}"], onComplete:completeMagnet, onCompleteParams:[cast(coll, Collectable)], ease:Quart.easeIn } );
			}
		}
	}
	
	/**
	 * Update la cible du tween gerant le magnet
	 * @param	tween objet TweenMax à update
	 */
	private function updateMagnet(tween:TweenMax ):Void {
		if(tween.target!=null)
			tween.updateTo( { x:x + hitCenter().x, y:y + hitCenter().y }, false);
		else tween.kill();
	}
	
	/**
	 * CallBack de complete du tween gerant le magnet
	 * @param	pColl le collectable à remove
	 */
	private function completeMagnet(pColl:Collectable):Void {
		removeCollectable(pColl);
	}
	
	/**
	 * Gere le deplacement en l'air
	 */
	private function airControl():Void {
		
		if (canLeft()) {
			acceleration.x = -accelerationAir;
			flipLeft();
		}
		else if (canRight()) {
			acceleration.x = accelerationAir;
			flipRight();
		}
	}
	
	/**
	 * Gere la collision enemi
	 */
	private function collisionWithEnnemies():Void {
		
		if (isGod) return;
		
		
		if (hitTestBox(Enemy.list, hitBox) == null && hitTestBox(KillZone.list, hitBox) == null)	{
			isBeinghurt = false;	
			alpha = 1;
		}
	
		if (hitTestBox(Enemy.list, hitBox) != null || hitTestBox(KillZone.list, hitBox) != null ){
			
			if(!isBeinghurt) setModeHurt();
			else alpha = 0.5;
			isBeinghurt = true;
			
			
		}	
	}
	
	/**
	 * Gere la collision avec le collectible win
	 */
	private function collisionWithWin():Void {
		collision = hitTestBox(CollectableWin.list, hitBox);
		if (collision != null) {
			setState(WAIT_STATE);
			GameManager.getInstance().stopGameloop();
			
			TweenMax.to(collision, 1, { y:y + 50, width:2 * collision.width, height:2 * collision.height, ease:Sine.easeOut } );
			TweenMax.to(collision, 0.5, { x:x, y:y, width:1, height:1, alpha:0, ease:Sine.easeIn, onComplete:GameManager.getInstance().win, delay:1 } );
			
			
		}
	}
	
	/**
	 * Rafraishi le score du HUD
	 */
	private function refreshScore():Void{
		actualScore=readScore();
		Hud.getInstance().ScoreText.text = "" + actualScore+"/"+LevelDesignManager.totalCollectable;
	}
	
	/**
	 * Va cherche le score dans le json
	 * @return le score
	 */
	private function readScore():Int{
		var score:Int=0;
		for(key in SaveManager.status.keys()){
			if (SaveManager.status.get(key).type == TypeName.COLLECTABLE && SaveManager.status.get(key).onStage) score++;
		}
		return score;
	}
	
	/*##### Points de collisions et cannes ######*/
	
	/**
	 * Donne le point focus de la camera
	 * @return mcCamera le point focus dans le player pour la camera
	 */
	private function camFocus():Point {
		return box.getChildByName("mcCamera").position;
	}
	/**
	 * Donne le point superieur du player
	 * @return mcTop le point superieur du player
	 */
	private function hitTop():Point {
		return box.toGlobal(box.getChildByName("mcTop").position);
	}
	
	/**
	 * Donne le point inferieur du player
	 * @return mcBottom le point inferieur du player
	 */
	private function hitBottom():Point {
		return box.toGlobal(box.getChildByName("mcBottom").position);
	}
	
	/**
	 * Donne le point devant le player
	 * @return mcFront le point devant du player
	 */
	private function hitFront():Point {
		return box.toGlobal(box.getChildByName("mcFront").position);
	}
	
	/**
	 * Donne le point à l'arriere du player
	 * @return mcBottom le à l'point arriere du player
	 */
	private function hitBack():Point {
		return box.toGlobal(box.getChildByName("mcBack").position);
	}
	
	/**
	 * Donne le canne inférieur du player
	 * @return mcCheckBottom la canne inferieur du player
	 */
	private function checkBottom():Point {
		return box.toGlobal(box.getChildByName("mcCheckBottom").position);
	}
	
	/**
	 * Donne le canne supérieur du player
	 * @return mcCheckTop la canne inferieur du player
	 */
	private function checkTop():Point {
		return box.toGlobal(box.getChildByName("mcCheckTop").position);
	}
	
	/**
	 * Donne le canne devant le player
	 * @return mcCheckFront la canne devant le player 
	 */
	private function checkFront():Point {
		return box.toGlobal(box.getChildByName("mcCheckFront").position);
	}
	
	/**
	 * Donne le canne à l'arriere du player
	 * @return mcCheckFront la canne à l'arriere du player
	 */
	private function checkBack():Point {
		return box.toGlobal(box.getChildByName("mcCheckBack").position);
	}
	
	/**
	 * Donne la boxe magnetique du player
	 * @return mcMagnet boxe magnetique du player
	 */
	private function hitMagnet():Container{
		return cast(box.getChildByName("mcMagnet"), Container);
	}
	
	/**
	 * Donne le point central player
	 * @return mcCenter le point central du player
	 */
	private function hitCenter():Point {
		return box.getChildByName("mcCenter").position;
	}
	
	public function getDetectLimit():Container{
		return cast(box.getChildByName("mcDetectLimit"), Container);
	}
	/**
	 * accesseur de la boute de collision global
	 * @return mcGlobalHitBox la boite de collision global
	 */
	override function get_hitBox():Container 
	{
		return cast(box.getChildByName("mcGlobalHitBox"),Container);
	}
	
	/* ##### Les Testeurs ##### */
	
	private function hitFloor(?pHit:Point):Bool {
		if (pHit == null) pHit = hitBottom();
		
		var lCollision:StateGraphic = testPoint(Wall.list, pHit);
		
		if (lCollision == null) lCollision = testPoint(Platform.list, pHit);
		
		if (lCollision != null) {
			floor = cast(lCollision, Stationary);
			y = floor.y;
			return true;
		}
		
		floor = null;
		return false;
	}
	
	
	
	/**
	 * Donne la possibilité de sauter
	 * @return true si peut sauter false sinon
	 */
	private function canJump():Bool {
		return controller.jump && !lastJump && testPoint(Wall.list, checkTop())==null;
	}
	
	/**
	 * Donne la possibilité de tomber
	 * @return true si peut tomber false sinon
	 */
	private function canFall():Bool {
		if (floor != null && testPoint([floor], checkBottom()) == floor) return false;
		return !hitFloor(checkBottom());
	}
	
	/**
	 * Donne la possibilité d'aller à gauche
	 * @return true si peut aller à gauche false sinon
	 */
	private function canLeft():Bool {
		//return controller.left && testPoint(Wall.list, scale.x==-1?checkFront():checkBack())==null;
		if (controller.left && testPoint(Wall.list, scale.x == -1?hitFront():hitBack()) == null) return true;
		else {
			var lColllision:StateGraphic = testPoint(Wall.list, scale.x == -1?hitFront():hitBack());
			if (lColllision!=null){
				wall = cast(lColllision, Stationary);
				x = wall.x+wall.hitBox.width + hitBox.width /2 +10;	
			}
		}
		return false;
	}
	/**
	 * Donne la possibilité d'aller à droite
	 * @return true si peut aller à droite false sinon
	 */
	private function canRight():Bool {
		if (controller.right && testPoint(Wall.list, scale.x == 1?hitFront():hitBack()) == null) return true;
		else {
			var lColllision:StateGraphic = testPoint(Wall.list, scale.x == 1?hitFront():hitBack());
			if (lColllision!=null){
				wall = cast(lColllision, Stationary);
				x = wall.x - hitBox.width / 2;
				
			}
			
		}
		return false;
		
		
	}
	
	private function hitCheckpoint():Void{
		var lCollision:StateGraphic = hitTestBox(Checkpoint.list, hitBox);
		if(lCollision!=null){
			checkPoint = cast(lCollision, Checkpoint);
			checkPoint.saveLocation();
		}
	}
	
	/**
	 * Sauvegarde le point de spawn du player
	 */
	private function firstSavePoint():Void {
		Browser.getLocalStorage().setItem("saveX", "" + x);
		Browser.getLocalStorage().setItem("saveY", "" + y);
	}
	
	override public function destroy():Void 
	{
		instance = null;
		emitter.cleanup();
		emitter.destroy();
		controller.destroy();
		super.destroy();
	}	
	
}