package com.isartdigital.utils.game;
import com.isartdigital.platformer.game.LevelDesignManager;
import com.isartdigital.platformer.game.sprites.mobiles.Player;
import com.isartdigital.platformer.game.sprites.planes.GamePlane;
import com.isartdigital.platformer.game.sprites.stationaries.Wall;
import com.isartdigital.platformer.game.TypeName;
import com.isartdigital.utils.game.clipping.ClippingManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
 
 
/**
 * Classe Camera
 * @author Mathieu ANTHOINE
 */
class Camera
{
   
    private var target:DisplayObject;
    private var focus:DisplayObject;
	private var center:Rectangle;
    private var easeMax:Point = new Point(40, 20);
    private var easeMin:Point = new Point(20, 8);
    private var countH:UInt = 0;
    private var delayH:UInt = 120;
    private var countV:UInt = 0;
    private var delayV:UInt = 60;
	
	
	public var velocity:Point=new Point(0,0);

    public var canMoveX:Bool = false;
    public var canMoveY:Bool = false;

	private var deltaX:Float;
	private var deltaXLeft:Float;
	private var deltaXRight:Float;
	private var deltaXZoneRight:Float;
	private var deltaXZoneLeft:Float;
	
	private var deltaYFall:Float;
	private var deltaYJump:Float;
	
	private var lastX:Float = 0;
	private var lastY:Float = 0;
	
	private var zoneSize(default, never):Float = 0.9;
	
	
	private var offsetClip:Float;
	private var offsetSizeClip:Float;
	
	public var distanceToFocusX:Float;
	public var distanceToFocusY:Float;
	
	private var lPosDeadZone:Point;
	private var lPosZoneRight:Point;
	private var lPosZoneLeft:Point;
	
	public var doShake:Bool = false;
	private var shakeCounter:Int = 0;
	private var  SHAKE_TIME(default, never):Int = 30;
	private var  SHAKE_OFFSET(default, never):Int = 20;
	private var tempTarget:DisplayObject;
	
	private var collision:Array <StateGraphic>=new Array <StateGraphic>();
	private var firstXSet:Bool=false;
	private var endXSet:Bool=false;
	private var firstX:Float=0;
	private var endX:Float=0;
	// a utilise en cas de debug
	private var g:Graphics;


   
    /**
     * instance unique de la classe GamePlane
     */
    private static var instance: Camera;
 
    /**
     * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
     * @return instance unique
     */
    public static function getInstance (): Camera {
        if (instance == null) instance = new Camera();
        return instance;
    }  
   
    private function new()
    {
        // g = new Graphics();
    }
   
    /**
     * Défini la cible de la caméra
     * @param   pTarget cible
     */
    public function setTarget (pTarget:DisplayObject):Void {
        target = pTarget;
    }
	
	 public function getTarget ():DisplayObject {
        return target;
    }
   
    /**
     * Défini l'élement à repositionner au centre de l'écran
     * @param   pFocus focus
     */
    public function setFocus(pFocus:DisplayObject):Void {
        focus = pFocus;
    }
	
	public function getFocus():DisplayObject {
        return focus;
    }
	
	public function getLocalFocusPoint():Point{
		return target.toLocal(focus.position, focus.parent);
	}
   
    /**
     * recadre la caméra
     * @param   pDelay si false, la caméra est recadrée instantannément
	 * @param   pFirstSet, 
     */
    private function changePosition (?pDelay:Bool=true,pMoveX:Bool=true,pMoveY:Bool=true) :Void {
       
        countH++;
        countV++;
        var lCenter:Rectangle = DeviceCapabilities.getScreenRect(target.parent);   
        var lScreen:Rectangle = DeviceCapabilities.getScreenRect(target); 
		
        var lFocus:Point = getLocalFocusPoint();
		
		offsetClip = lScreen.width / 2;
		offsetSizeClip = offsetClip * 2;
		
		velocity.set( pMoveX?changeX(lCenter, lFocus, pDelay):0, pMoveY?changeY(lCenter, lFocus, pDelay):0 );
		if (firstXSet && lScreen.x <= firstX && deltaX != deltaXRight) velocity.x = 0;
		if (endXSet && lScreen.x + lScreen.width >= endX && deltaX != deltaXLeft) velocity.x = 0;
			
		
		target.x += velocity.x;
		target.y += velocity.y;
		
		if (Math.abs(lastX - lFocus.x) > 280 || Math.abs(lastY - lFocus.y) > 280 || Player.getInstance().isRespawn())  {
			lastX = lFocus.x;
			lastY = lFocus.y;
			var clipZone:Rectangle = new Rectangle(lScreen.x - offsetClip, lScreen.y - offsetClip, lScreen.width + offsetSizeClip, lScreen.height + offsetSizeClip);
			ClippingManager.update(clipZone);
		}
		
		
		
    }
	private  function dectectLimit():Void {
		collision = Player.getInstance().hitTestMultiBox(Wall.list, Player.getInstance().getDetectLimit());
		if (collision.length!=0) {
			
			for(wall in collision){
				if (wall.getAssetName()==TypeName.LIMIT_LEFT &&!firstXSet ){
					firstX = wall.x;
					firstXSet = true;
				}
				else if(wall.getAssetName()==TypeName.LIMIT_RIGHT&& !endXSet){
					endX = wall.x + 280;
					endXSet = true;
				}
				collision.remove(wall);
			}
		}
	}
   
    private function changeX(lCenter:Rectangle, lFocus:Point, ?pDelay:Bool=true):Float{
        var lEaseX:Float = pDelay ? getEaseX() : 1;
        distanceToFocusX = lCenter.x + lCenter.width / 2 - lFocus.x - target.x;
        return distanceToFocusX / lEaseX;
    }
   
    private function changeY(lCenter:Rectangle, lFocus:Point, ?pDelay:Bool=true):Float{
        var lEaseY:Float = pDelay ? getEaseY() : 1;
        distanceToFocusY = lCenter.y + lCenter.height / 2 - lFocus.y - target.y;
        return  distanceToFocusY / lEaseY;
    }
   
	
    /**
     * retourne une inertie en X variable suivant le temps
     * @return inertie en X
     */
    private function getEaseX() : Float {
        if (countH > delayH) {
			//canMoveX = false;
			return easeMin.x;
		}
        return easeMax.x + (easeMin.x-easeMax.x)*countH/delayH;
    }
 
    /**
     * retourne une inertie en Y variable suivant le temps
     * @return inertie en Y
     */
    private function getEaseY() : Float {
        if (countV > delayV) 
			return easeMin.y;
        return easeMax.y + (easeMin.y-easeMax.y)*countV/delayV;
    }
   
    /**
     * cadre instantannément la caméra sur le focus
     */
    public function setPosition():Void {
        GameStage.getInstance().render();
        changePosition(false);
    }
   
     /**
     * cadre la caméra sur le focus avec de l'inertie
     */
    public function move():Void {
		center = DeviceCapabilities.getScreenRect(target);   
		
		shakeScreen();
		lPosZoneLeft = new Point(center.x + center.width - center.width / 6, center.y);
		lPosDeadZone = new Point(center.x+center.width/3, center.y);
		lPosZoneRight = new Point(center.x + center.width / 6, center.y);
		
		deltaCalcul();
		
		if (Player.getInstance().scale.x==1){
			if (deltaXZoneLeft < 0) deltaX = deltaXRight
			else if (Player.getInstance().x>lPosDeadZone.x && Player.getInstance().x<lPosDeadZone.x + center.width/3 ) deltaX = deltaXRight;
			else if(Player.getInstance().x>lPosZoneRight.x && Player.getInstance().x<lPosDeadZone.x-20){
				deltaX = null;
				canMoveX=false;
			}
		}
		else if(Player.getInstance().scale.x==-1){
			if (deltaXZoneRight < 0)  deltaX = deltaXLeft
			else if (Player.getInstance().x>lPosDeadZone.x && Player.getInstance().x<lPosDeadZone.x + center.width/3 ) deltaX = deltaXLeft; 
			else if(Player.getInstance().x<lPosZoneLeft.x && Player.getInstance().x>lPosDeadZone.x + (center.width/3)+20){
				deltaX = null;
				canMoveX=false;
			}
		}
		if (deltaX <0) canMoveX = true;
		dectectLimit();
		if (Player.getInstance().isRespawn()) {
			canMoveY = true;
			canMoveX = true;
		}
		if (deltaYFall < center.height / 4) canMoveY = true;
		
		//if (Config.debug) drawDeadZone();
		changePosition(true,canMoveX,canMoveY);
		
    }
	private function deltaCalcul() {
		deltaXZoneLeft = lPosZoneLeft.x - Player.getInstance().x;
		deltaXZoneRight= Player.getInstance().x - lPosZoneRight.x;
		deltaXLeft = Player.getInstance().x-(lPosDeadZone.x + center.width);
		deltaXRight = lPosDeadZone.x - Player.getInstance().x ;
		deltaYFall = lPosDeadZone.y +center.height - Player.getInstance().y;
	}
	private function drawDeadZone():Void{
		
		g.clear();
		g.beginFill();
		g.alpha = 0.5;
        g.drawRect(lPosDeadZone.x, lPosDeadZone.y, center.width/3, center.height);
        g.drawRect(lPosZoneLeft.x, lPosDeadZone.y, center.width/6, center.height);
        g.drawRect(lPosZoneRight.x, lPosDeadZone.y, -center.width/6, center.height);
        g.endFill();
        GamePlane.getInstance().addChild(g);
	}
	
	public function shakeScreen():Void {
		if (doShake) {
			shakeCounter++;
			target.x = tempTarget.x + Math.random() * SHAKE_OFFSET * 2 - SHAKE_OFFSET;
			target.y = tempTarget.y + Math.random() * SHAKE_OFFSET * 2 - SHAKE_OFFSET;
			
			if (shakeCounter == SHAKE_TIME) {
				target.x = tempTarget.x;
				target.y = tempTarget.y;
				doShake = false;
			}
		}else {
			shakeCounter = 0;
			tempTarget = getTarget();
		}
	}
    /**
     * remet à zéro le compteur qui fait passer la caméra de l'inertie en X maximum à minimum
     */
    public function resetX():Void {
        countH = 0;
		
    }
 
    /**
     * remet à zéro le compteur qui fait passer la caméra de l'inertie en Y maximum à minimum
     */
    public function resetY():Void {
        countV = 0;
    }
   
    /**
     * détruit l'instance unique et met sa référence interne à null
     */
    public function destroy (): Void {
        instance = null;
    }
   
}