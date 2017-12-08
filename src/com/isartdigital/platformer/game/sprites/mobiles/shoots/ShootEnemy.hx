package com.isartdigital.platformer.game.sprites.mobiles.shoots;

/**
 * ...
 * @author Eimin
 */
class ShootEnemy extends Shoot
{

	public function new(pAsset:String) 
	{
		super(pAsset);
		
	}
	override public function init():Void 
	{
		super.init();
		if (assetName == "ShootEnemyTurret") {
			toggleCollision = false;
			coef = 0.1;
			return;
		}
		assetName = "ShootEnemyTurret";
		setState(BEGIN_STATE);
	}
	override function collisions():Void 
	{
		enemyCollision();
		super.collisions();	
	}
	
}