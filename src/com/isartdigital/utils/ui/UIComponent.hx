package com.isartdigital.utils.ui;

import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.UIPositionable;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

/**
 * Base de tous les conteneurs d'interface
 * @author Mathieu ANTHOINE
 */
class UIComponent extends GameObject
{

	private var positionables:Array<UIPositionable> = [];
	
	private var isOpened:Bool;
	
	private var modalZone:Sprite;
	
	private var _modal:Bool = true;
	
	// TODO: pouvoir le varier dynamiquement
	public var modalImage:String="assets/alpha_bg.png";
	
	public function new() 
	{
		super();
	}
	
	public function open (): Void {
		if (isOpened) return;
		isOpened = true;
		modal = _modal;
		GameStage.getInstance().on(EventType.RESIZE, onResize);
		onResize();
	}
	
	//TODO: verifier si y a besoin d'une variable privée ou si on peut utiliser modal direct
	
	public var modal (get, set):Bool;
	
	private function get_modal ():Bool {
		return _modal;
	}
	
	private function set_modal (pModal:Bool):Bool {
		_modal = pModal;
		
		if (_modal) {
			if (modalZone == null) {
				modalZone = new Sprite(Texture.fromImage(Config.url(modalImage)));
				modalZone.interactive = true;
				modalZone.on(MouseEventType.CLICK, stopPropagation);
				modalZone.on(TouchEventType.TAP, stopPropagation);
				positionables.unshift({ item:modalZone, align:UIPosition.FIT_SCREEN, offsetX:0, offsetY:0});
			}
			if (parent != null) parent.addChildAt(modalZone, parent.getChildIndex(this));
		} else {	
			if (modalZone != null) {
				if (modalZone.parent != null) modalZone.parent.removeChild(modalZone);
				modalZone.off(MouseEventType.CLICK, stopPropagation);
				modalZone.off(TouchEventType.TAP, stopPropagation);
				modalZone = null;
				if (positionables[0].item == modalZone) positionables.shift();
			}
		}
		
		return _modal;
	}
	
	private function stopPropagation (pEvent:EventTarget): Void {}
	
	public function close ():Void {
		if (!isOpened) return;
		isOpened = false;
		modal = false;
		destroy();
	}
	
	/**
	 * déclenche le positionnement des objets
	 * @param pEvent
	 */
	private function onResize (pEvent:EventTarget = null): Void {
		for (lObj in positionables) {
			if (lObj.update) {
				if (lObj.align==UIPosition.TOP || lObj.align==UIPosition.TOP_LEFT || lObj.align==UIPosition.TOP_RIGHT) {
					lObj.offsetY = parent.y + lObj.item.y;
				} else if (lObj.align==UIPosition.BOTTOM || lObj.align==UIPosition.BOTTOM_LEFT || lObj.align==UIPosition.BOTTOM_RIGHT) {	
					lObj.offsetY = GameStage.getInstance().safeZone.height - parent.y - lObj.item.y;
				}
				
				if (lObj.align==UIPosition.LEFT || lObj.align==UIPosition.TOP_LEFT || lObj.align==UIPosition.BOTTOM_LEFT) {
					lObj.offsetX = parent.x + lObj.item.x;
				} else if (lObj.align==UIPosition.RIGHT || lObj.align==UIPosition.TOP_RIGHT || lObj.align==UIPosition.BOTTOM_RIGHT) {	
					lObj.offsetX = GameStage.getInstance().safeZone.width - parent.x - lObj.item.x;
				}
				
				lObj.update = false;
			}
			UIPosition.setPosition(lObj.item, lObj.align, lObj.offsetX, lObj.offsetY);
		}
	}
	
	/**
	 * nettoie l'instance
	 */
	override public function destroy (): Void {
		close();
		GameStage.getInstance().off(EventType.RESIZE, onResize);
		super.destroy();
	}
	
}