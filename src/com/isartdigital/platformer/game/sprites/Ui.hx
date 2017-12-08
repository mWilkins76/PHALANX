package com.isartdigital.platformer.game.sprites;

import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author Eimin
 */
class Ui extends StateGraphic
{
	//liste des différents ecrans disponible
	private var LOADER(default, never):String = "loader";
	private var LOADER_HELP(default, never):String = "loaderhelp";
	private var TITLECARD(default, never):String = "titlecard";
	private var CREDITS(default, never):String = "credits";
	private var LEVELSCREEN(default, never):String = "levelscreen";
	private var PRELOAD(default, never):String = "preload";
	private var PRELOADBG(default, never):String = "preloadbg";
	private var PAUSE(default, never):String = "pause";
	private var SUPERSHOOT(default, never):String = "supershoot";
	private var JUMP(default, never):String = "jump";
	private var SHIELD(default, never):String = "shield";
	private var COLLECTABLE(default, never):String = "collectable";
	private var COLLECTABLEJUMP(default, never):String = "collectiblejump";
	private var COLLECTABLESHIELD(default, never):String = "collectibleshield";
	private var COLLECTABLESHOOT(default, never):String = "collectibleshoot";
	
	public function new() 
	{
		super();
	}
	
	/**
	 * Permet de mettre l'état d'écran titre
	 */
	public function setModeTitleCard():Void {
		setState(TITLECARD);	
	}
	
	/**
	 * Permet de mettre l'état d'écran de chargement
	 */
	public function setModeLoader():Void {
		setState(LOADER);	
	}
	
	public function setModeLoaderHelp():Void {
		setState(LOADER_HELP);	
	}
	
	/**
	 * Permet de mettre l'état d'écran de crédits
	 */
	public function setModeCredits():Void {
		setState(CREDITS);	
	}
	
	/**
	 * Permet de mettre l'état d'écran de selection des niveau
	 */
	public function setModeLevelScreen():Void{
		setState(LEVELSCREEN);	
	}
	
	/**
	 * Permet de mettre l'état de barre de chargement
	 */
	public function setModePreload():Void{
		setState(PRELOAD);	
	}
	
	/**
	 * Permet de mettre l'état de background de barre de chargement
	 */
	public function setModePreloadBg():Void{
		setState(PRELOADBG);	
	}
	
	public function setModePause():Void{
		setState(PAUSE);
	}
	public function setModeSuperShoot():Void{
		setState(SUPERSHOOT);
	}
	public function setModeJump():Void{
		setState(JUMP);
	}
	public function setModeShield():Void{
		setState(SHIELD);
	}
	public function setModeCollectable():Void{
		setState(COLLECTABLE);
	}
	public function setModeCollectableShield():Void{
		setState(COLLECTABLESHIELD);
	}
	public function setModeCollectableJump():Void{
		setState(COLLECTABLEJUMP);
	}
	public function setModeCollectableShoot():Void{
		setState(COLLECTABLESHOOT);
	}
	
}