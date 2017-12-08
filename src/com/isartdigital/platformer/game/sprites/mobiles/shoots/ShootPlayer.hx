package com.isartdigital.platformer.game.sprites.mobiles.shoots;
import com.isartdigital.platformer.game.sprites.mobiles.enemies.Enemy;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.sounds.SoundManager;

/**
 * ...
 * @author Eimin
 */
class ShootPlayer extends Shoot
{

	private var REVERSEBEGIN_STATE(default, never):String = 'reversebegin';
	private var REVERSEEND_STATE(default, never):String = 'reverseend';
	private var isReverse:Bool = false;
	public function new(pAsset:String) 
	{
		super(pAsset);
		
	}
	override public function init():Void 
	{
		super.init();
		if (assetName == "SuperShootPlayer") isSuperShoot = true;
		if (isSuperShoot) SoundManager.getSound("supershoot_launch").play();
		
	}
	override function collisions():Void 
	{
		super.collisions();
		if (isReverse) {
			enemyCollision();
			return;
		}
		collision = hitTestBox(Enemy.list, hitBox);
		if (collision != null ) {
			enemy = cast(collision, Enemy);
			if (isSuperShoot) {
					enemy.setModeDie();
					SoundManager.getSound("supershoot_explode").play();
					Camera.getInstance().doShake = true;
					if (!Player.getInstance().isGod)setModeEnd();
					return;
			}
			else if (enemy.assetName == TypeName.ENEMY_BOMB) {
				reverse();
				return;
			}
			else{
				enemy.life--;
				SoundManager.getSound("spear_hit_flesh").play();
				//if(isSuperShoot)SoundManager.getSound("supershoot_explode").play();
				enemy.setModeHurt();
				setModeEnd();
			}
		}
		
	}
	private function reverse():Void{
		angle = (rotation == 0?Math.PI:0);
		//angle =(rotation == 0?-((Math.PI/2)+Math.random()*Math.PI/2):-Math.random()*Math.PI/2);
		rotation = angle;
		isReverse = true;
		coef = 0.5;
		setState(REVERSEEND_STATE);
		
	}
	override public function setModeEnd():Void 
	{
		super.setModeEnd();
		if (isReverse)setState(REVERSEBEGIN_STATE);
	}
	
}