package com.isartdigital.platformer.ui;
import com.isartdigital.platformer.game.sprites.mobiles.Player;
import com.isartdigital.platformer.Main;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.effects.Trail;
import com.isartdigital.utils.game.Camera;
import com.isartdigital.utils.game.GameStage;
import dat.gui.GUI;

	
/**
 * Classe permettant de manipuler des parametres du projet au runtime
 * Si la propriété Config.debug et à false ou que la propriété Config.data.cheat est à false, aucun code n'est executé.
 * Il n'est pas nécessaire de retirer ou commenter le code du CheatPanel dans la version "release" du jeu
 * @author Mathieu ANTHOINE
 */
class CheatPanel 
{
	
	/**
	 * instance unique de la classe CheatPanel
	 */
	private static var instance: CheatPanel;
	
	/**
	 * instance de dat.GUI composée par le CheatPanel
	 */
	private var gui:GUI;
	private var trail:Trail;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CheatPanel {
		if (instance == null) instance = new CheatPanel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		init();
	}
	
	private function init():Void {
		if (Config.debug && Config.data.cheat) gui = new GUI();
	}
	
	// exemple de méthode configurant le panneau de cheat suivant le contexte
	public function ingame (): Void {
		// ATTENTION: toujours intégrer cette ligne dans chacune de vos méthodes pour ignorer le reste du code si le CheatPanel doit être désactivé
		if (gui == null) return;
		
		var lPosition: GUI = gui.addFolder("position");
		lPosition.open();
		
		var lVelocity: GUI = gui.addFolder("velocity");
		lVelocity.open();
		
		var lAcc: GUI = gui.addFolder("acceleration");
		lAcc.open();
		
		var lParams: GUI = gui.addFolder("paramètres");
		lParams.open();
		
		lPosition.add(untyped Player.getInstance(), "state").listen();
		lPosition.add(Player.getInstance().position, "x").listen();
		lPosition.add(Player.getInstance().position, "y").listen();
		
		lVelocity.add(untyped Player.getInstance().velocity, "x").listen();
		lVelocity.add(untyped Player.getInstance().velocity, "y").listen();
		
		lAcc.add(untyped Player.getInstance().acceleration, "x").listen();
		lAcc.add(untyped Player.getInstance().acceleration, "y").listen();
		
		lParams.add(untyped Player.getInstance(), "frictionGround").min(0.5).max(1).step(0.05).listen();
		lParams.add(untyped Player.getInstance(), "accelerationGround").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance(), "frictionAir").min(0.5).max(1).step(0.05).listen();
		lParams.add(untyped Player.getInstance(), "accelerationAir").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance(), "impulse").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance(), "doubleImpulse").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance(), "gravity").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance().hitMagnet().scale, "x").min(0).max(50).listen();
		lParams.add(untyped Player.getInstance().hitMagnet().scale, "y").min(0).max(50).listen();
		
		trail = new Trail(Main.getInstance(), Player.getInstance());
		
		//gui.add(GameStage.getInstance(), "x", -1000, 1000).listen();
		//gui.add(GameStage.getInstance(), "y", -500, 500).listen();		
	}
	
	public function setCamera (): Void {
		// ATTENTION: toujours intégrer cette ligne dans chacune de vos méthodes pour ignorer le reste du code si le CheatPanel doit être désactivé
		if (gui == null) return;
		
		var lCam: GUI = gui.addFolder("Focus Caméra");
		lCam.open();
		
		var lMax: GUI = gui.addFolder("Inertie Max");
		lMax.open();
		
		var lMin: GUI = gui.addFolder("Inertie Min");
		lMin.open();
		
		var lMar: GUI = gui.addFolder("Margins");
		lMar.open();
		
		
		
		lCam.add(untyped Player.getInstance().box.getChildByName("mcCamera").position, "x").min(0).max(1000).step(5).listen();	
		lCam.add(untyped Player.getInstance().box.getChildByName("mcCamera").position, "y").min(-500).max(50).step(5).listen();
		
		lMax.add(untyped Camera.getInstance().easeMax, "x").min(0).max(100).step(1).listen();	
		lMax.add(untyped Camera.getInstance().easeMax, "y").min(0).max(100).step(1).listen();
		
		lMin.add(untyped Camera.getInstance().easeMin, "x").min(0).max(100).step(1).listen();	
		lMin.add(untyped Camera.getInstance().easeMin, "y").min(0).max(100).step(1).listen();
		
		
		lMar.add(untyped Player.getInstance(), "STOP_CAM").min(0).max(60).step(1).listen();
		lMar.add(untyped Camera.getInstance(), "zoneSize").min(1).max(4).step(0.01).listen();
		
		
		trail = new Trail(Main.getInstance(), Player.getInstance());
			
	}
	
	
	
	/**
	 * vide le CheatPanel
	 */
	public function clear ():Void {
		if (gui == null) return;
		
		trail.destroy();
		trail = null;
		gui.destroy();
		init();
	}	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}