package com.isartdigital.utils.effects;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.GameObject;
import eventemitter3.EventEmitter;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;

/**
 * Classe qui permet d'ajouter une trainée derrière un DisplayObject afin d'analyser son mouvement
 * @author Mathieu ANTHOINE
 */
class Trail extends GameObject
{

	private var emitter:EventEmitter;
	private var target:DisplayObject;
	private var frequency:Float;
	private var counter:UInt = 0;
	private var list:Array<Container> = [];
	private var oldPos:Point = new Point(0, 0);
	private var persistence:Float;	
	
	/**
	 * @param	pGameLoopEmitter référence vers l'émetteur de GameLoop
	 * @param	pTarget cible du Trail
	 * @param	pFrequency fréquence d'apparition des points (0 (importante) et 1 (faible))
	 * @param	pPersistence persistence des points à l'écran (0 (rapide) à 1 (permanent))
	 */
	public function new(pGameLoopEmitter:EventEmitter,pTarget:DisplayObject,pFrequency:Float=0,pPersistence:Float=0) 
	{
		super();
		emitter = pGameLoopEmitter;
		target = pTarget;
		frequency = Math.max(0,Math.min(pFrequency,1)) * 4;
		persistence = 0.95 + Math.max(0, Math.min(pPersistence, 1)) / 20;
		target.parent.addChildAt(this, target.parent.getChildIndex(target));
		start();
		
	}
	
	override private function setModeNormal():Void {
		super.setModeNormal();
		emitter.on(EventType.GAME_LOOP, doAction);
	}
	
	override function doActionNormal ():Void {
		
		for (i in 0...list.length) {
			list[i].scale.x *= persistence;
			list[i].scale.y *= persistence;
			list[i].alpha *= persistence;
		}
		
		if (list.length>0 && list[0].scale.x < 0.1) removeChild(list.shift());
		
		if (++counter > frequency && (oldPos.x!=target.x || oldPos.y!=target.y)) {
			var lCircle:Container = new Container();
			var lGraph:Graphics = new Graphics();
			lGraph.beginFill(0xFFFFFF);
			lGraph.drawCircle(0,0, 20);
			lGraph.endFill();
			lCircle.position = target.position.clone();
			lCircle.addChild(lGraph);
			addChild(lCircle);
			list.push(lCircle);
			counter = 0;
		}
		
		oldPos = target.position.clone();
	}
	
	override public function destroy():Void {
		emitter.off(EventType.GAME_LOOP, doAction);
		emitter = null;
		target.parent.removeChild(this);
		target = null;
		super.destroy();
	}
	
}