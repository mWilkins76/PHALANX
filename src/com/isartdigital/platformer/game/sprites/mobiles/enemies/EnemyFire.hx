package com.isartdigital.platformer.game.sprites.mobiles.enemies;

import com.isartdigital.platformer.game.sprites.mobiles.shoots.Shoot;
import com.isartdigital.platformer.game.sprites.mobiles.shoots.ShootEnemy;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.platformer.game.sprites.stationaries.Platform;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.filters.color.ColorMatrixFilter;

/**
 * ...
 * @author dachicourt jordan
 */
class EnemyFire extends EnemyMovable
{


	private var groundAcceleration(default, never):Float = 15;
	private var COUNT_TURN(default, never):Float = 30;

	private var wallUp:StateGraphic;
	private var wallDown:StateGraphic;

	private var hurtFilter:ColorMatrixFilter = new ColorMatrixFilter();
	private var isHurt:Bool = false;
	private var hurtCounter:Int = 0;

	private var isDetecting:Bool = false;

	public function new()
	{
		super(name);

	}

	override public function init():Void
	{
		super.init();
		FIRE_RATE = 45;
		accelerationGround = groundAcceleration;
		maxHSpeed = 5;
		life = 7;
	}

	override function doActionWait():Void
	{

		super.doActionWait();
		hurtCheck();
		if (detectPlayer()) {
			setModeShoot();
			return;
		}
	}

	override function doActionNormal():Void
	{
		super.doActionNormal();
		setModeMovement();
		hurtCheck();

	}

	override private function doActionMovement():Void
	{
		
		hurtCheck();

		if (anim.currentFrame==0) SoundManager.getSound("cyclope_footsteps1").play();
		if (anim.currentFrame==19) SoundManager.getSound("cyclope_footsteps2").play();
		if (detectPlayer())return;

		walk();

		wallUp = testPoint(Wall.list, hitFront());
		wallDown = testPoint(Wall.list, hitFrontDown());
		if (wallDown != null || wallUp != null || (testPoint(Platform.list, hitFloor()) == null && testPoint(Wall.list, hitFloor()) == null)) setModeWait();

	}
	override public function setModeWait():Void
	{
		if (detectPlayer()) {
			setModeShoot();
			return;
		}
		super.setModeWait();
	}
	public function setModeShoot():Void {

		SoundManager.getSound("cyclope_detect").play();
		setState(WAITSHOOT_STATE);
		doAction = doActionShoot;
	}
	private function detectPlayer():Bool{
		if (CollisionManager.hasCollision(hitDetection(), Player.getInstance().hitBox)) {

			isDetecting = true;
			setModeShoot();
			return isDetecting;
		}
		isDetecting = false;
		return isDetecting;
	}
	private function doActionShoot():Void {

		hurtCheck();
		fireCounter++;
		scale.x = (Player.getInstance().x - x > 0?1: -1);
		if (fireCounter > FIRE_RATE) createShoot();
		if (!CollisionManager.hasCollision(hitDetection(), Player.getInstance().hitBox)) setModeMovement();
	}

	private function createShoot():Void {

		SoundManager.getSound("cyclope_shoot").play();

		shoot = cast(PoolManager.getFromPool(Shoot.ENEMYFIRE),Shoot);
		shoot.init();
		shoot.position = GamePlane.getInstance().toLocal(weaponOrigin());
		shoot.setAngle(scale.x == 1?0:Math.PI);
		parent.addChild(shoot);
		shoot.start();
		fireCounter = 0;
	}





	private function  hurtCheck():Void {
		
		if (!isHurt) return;
		else {
			if (++hurtCounter > 1) {
				anim.filters = null;
				hurtCounter = 0;
				isHurt = false;
			}
		}


	}

	override function setModeHurt():Void
	{
		if (life > 0) {
			hurtFilter.negative(true);
			anim.filters = [hurtFilter];
			isHurt = true;
		}
		else setModeDie();
	}

	private function hitFrontDown():Point{
		return box.toGlobal(box.getChildByName("mcFrontDown").position);
	}

	override function setModeDie():Void
	{
		SoundManager.getSound("cyclope_die").play();
		super.setModeDie();
	}
}
