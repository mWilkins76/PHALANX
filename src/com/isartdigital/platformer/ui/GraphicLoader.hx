package com.isartdigital.platformer.ui;

import com.isartdigital.platformer.game.sprites.Ui;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

/**
 * Preloader Graphique principal
 * @author Mathieu ANTHOINE
 */
class GraphicLoader extends Screen 
{
	
	/**
	 * instance unique de la classe GraphicLoader
	 */
	private static var instance: GraphicLoader;

	private var loaderBar:Ui;
	private var background:Ui;
	public static var isHelp:Bool = false;

		public function new() 
	{
		super();
		background = new Ui();
		
		if (isHelp && DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP) background.setModeLoaderHelp();
		else background.setModeLoader();
		
		
		var lBg:Ui = new Ui();
		lBg.setModePreloadBg();
	
		loaderBar = new Ui ();
		loaderBar.setModePreload();
		loaderBar.x = -loaderBar.width / 2;
		loaderBar.scale.x = 0;
		
		if (isHelp && DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP) {
			background.setModeLoaderHelp();
			lBg.y = background.height / 3.4;
			loaderBar.y = background.height / 3.4;
		}
		else background.setModeLoader();
		
		addChild(background);
		addChild(lBg);
		addChild(loaderBar);
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GraphicLoader {
		if (instance == null) instance = new GraphicLoader();
		return instance;
	}
	
	/**
	 * mise à jour de la barre de chargement
	 * @param	pProgress
	 */
	public function update (pProgress:Float): Void {
		loaderBar.scale.x = pProgress;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}