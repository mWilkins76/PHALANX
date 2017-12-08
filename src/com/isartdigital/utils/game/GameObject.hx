package com.isartdigital.utils.game;

import com.isartdigital.utils.events.EventType;
import pixi.core.display.Container;

/**
 * Classe de base des objets interactifs dans le jeu
 * Met à jour automatiquement ses données internes de position et transformation
 * 
 * @author Mathieu ANTHOINE
 */
class GameObject extends Container
{

	/**
	 * méthode appelée à chaque gameLoop. Elle peut faire référence à différentes méthodes au cours du temps
	 */
	public var doAction:Dynamic;	
	
	public function new() 
	{
		super();
		on(EventType.ADDED, forceUpdateTransform);
		setModeVoid();
	}
	
	/**
	 * Force la mise à jour de la matrices de transformation des éléments constituant le GameObject
	 */
	private function forceUpdateTransform (): Void {
		untyped updateTransform();
	}
	
	/**
	 * applique le mode "ne fait rien"
	 */
	private function setModeVoid (): Void {
		doAction = doActionVoid;
	}
	
	/**
	 * fonction vide destinée à maintenir la référence de doAction sans rien faire
	 */
	private function doActionVoid (): Void {}

	
	/**
	 * applique le mode normal (mode par defaut)
	 */
	private function setModeNormal(): Void {
		doAction = doActionNormal;
	}
	
	/**
	 * fonction destinée à appliquer un comportement par defaut
	 */
	private function doActionNormal (): Void {}
	
	/**
	 * Activation
	 */
	public function start (): Void {
		setModeNormal();
	}
	
	/**
	 * nettoie et détruit l'instance
	 */
	override public function destroy (): Void {
		setModeVoid();
		off(EventType.ADDED, forceUpdateTransform);
		super.destroy(true);
	}
	
}