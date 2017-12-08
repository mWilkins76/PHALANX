package com.isartdigital.platformer.game.sprites.mobiles.shoots;

import com.isartdigital.platformer.game.sprites.Mobile;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.Enemy;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * ...
 * @author Eimin
 */
class Shoot extends Mobile
{
	public static var list:Array<Shoot> = new Array<Shoot>();
	
	public static inline var ENEMYTURRET:String = "ShootEnemyTurret";
	public static inline var ENEMYFIRE:String = "ShootEnemyFire";
	public static inline var PLAYER:String = "ShootPlayer";
	public static inline var SUPER:String = "SuperShootPlayer";
	
	private var BEGIN_STATE(default, never):String = 'begin';
	private var END_STATE(default, never):String = 'end';
	
	private var  SHOOT_SPEED(default, never):Int = 60;
	
	private var angle:Float = 0;
	
	private var toggleCollision:Bool = true;
	
	private var isSuperShoot:Bool = false; 
	private var coef:Float=1;
	
	private var wall:Wall;
	private var enemy:Enemy;
	private var collision:StateGraphic;
	private var lscreen:Rectangle;
	public function new(pAsset:String) 
	{
		super(pAsset);
	}
	public function setAngle(pAngle:Float):Void{
		angle = pAngle;
	}
	override public function init():Void 
	{
		list.push(this);
		super.init();
	}
	override public function start():Void 
	{
		setModeNormal();
	}
	override function setModeNormal():Void 
	{
		setState(BEGIN_STATE);
		doAction = doActionNormal;
	}
	override function doActionNormal():Void 
	{
		lscreen=DeviceCapabilities.getScreenRect(GamePlane.getInstance()); 
		rotation = angle;
		x += Math.cos(angle) * (SHOOT_SPEED*coef);
		y += Math.sin(angle) * (SHOOT_SPEED * coef);
		if (x < lscreen.x || x > lscreen.x + lscreen.width) {
			dispose();
			if (isSuperShoot) {
				SoundManager.getSound("supershoot_explode").play();
				Camera.getInstance().doShake = true;
			}
			return;
		}
		collisions();
		
	}
	override function collisions():Void 
	{
		if (toggleCollision) {
			collision = hitTestPointToBox(Wall.list, hitBox);
			if (collision != null ) {
				wall = cast(collision, Wall);
				if (isSuperShoot) {
					SoundManager.getSound("supershoot_explode").play();
					Camera.getInstance().doShake = true;
				}
				else SoundManager.getSound("spear_hit_wall").play();
				setModeEnd();
				if (wall.assetName == TypeName.DESTRUCTIBLE && isSuperShoot) wall.setModeExplosion();
			}
		}
	}
	private function enemyCollision():Void{
		if(!Player.getInstance().isGod){
			if(CollisionManager.hasCollision(Player.getInstance().hitBox,hitBox)){
				setModeEnd();
				Player.getInstance().setModeHurt();
			}
		}
	}
	override function get_hitPoints():Array<Point> 
	{
		return [getPoint()];
	}
	private function getPoint():Point{
		return box.toGlobal(box.getChildByName("mcPoint").position);
	}
	
	public function setModeEnd():Void
	{
		setState(END_STATE);
		doAction = doActionEnd;
	}
	private function doActionEnd():Void
	{
		if (isAnimEnd) 
		{
			collision = null;
			dispose();
		}
	}
	override public function dispose():Void 
	{
		list.remove(this);
		super.dispose();
	}
}