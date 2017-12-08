package com.isartdigital.platformer.ui.screens;

import com.greensock.easing.Quad;
import com.greensock.TweenMax;
import com.isartdigital.platformer.game.GameManager;
import com.isartdigital.platformer.game.sprites.Ui;
import com.isartdigital.platformer.ui.screens.buttons.ButtonUi;
import com.isartdigital.platformer.ui.UIManager;
import com.isartdigital.platformer.ui.GraphicLoader;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import js.Browser;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author dachicourt jordan
 */
class LevelScreen extends Screen
{


	
	/**
	 * instance unique de la classe TitleCard
	 */
	private static var instance: LevelScreen;
	
	//Boutons de selection des levels
	private var levelButtons:Array<ButtonUi>;
	private static inline var NB_LEVELS: Int = 3;
	
	//Level Choisi
	private var selectedLevel:String;
	
	//BackGround du selecteur de niveaux
	private var background:Ui;
	private var collectibleWin:Ui;
	private var myDelay:Float = 0;
	private var check:Int;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelScreen {
		if (instance == null) instance = new LevelScreen();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new() 
	{
		super();
		check = 0;
		//creation du Background et affichage;
		background = new Ui();
		background.setModeLevelScreen();
		
		
		//creation du tabbleau de boutons de selection de niveau
		levelButtons = createButtonArray();
		
		//Test de sauvegarde
		if (Browser.getLocalStorage().getItem("rand")!="done"){
			
			//triage random du tableau de bouton de selections de niveaux
			levelButtons = randomArray(levelButtons);
			
			//association de position a chacun des bouton des niveaux et association d'evenement
			for (i in 0 ... NB_LEVELS) {
				levelButtons[i].x = levelButtons[i].width * (1 / 2 + i) - (background.width / 2);
				levelButtons[i].y = -2 * background.height;
				Browser.getLocalStorage().setItem(levelButtons[i].getName(), Std.string(levelButtons[i].x));
				addChild(levelButtons[i]);
				TweenMax.to(levelButtons[i], 1, { y:0, alpha:1, onComplete:addEvent,ease:Quad.easeIn, delay:myDelay } );
				myDelay += 0.25;
			}
		}
		else {
			
			//association des positions prééxistante des boutons de niveaux et association d'evenement
			for (m in 0...NB_LEVELS){
				levelButtons[m].x = Std.parseFloat(Browser.getLocalStorage().getItem(levelButtons[m].getName()));
				levelButtons[m].y = -2 * background.height;
				addChild(levelButtons[m]);
				TweenMax.to(levelButtons[m], 1, { y:0, alpha:1, onComplete:addEvent, ease:Quad.easeIn, delay:myDelay } );
				myDelay += 0.25;
			}
		}
		addChild(background);
		
		
	}
	private function addEvent():Void {
		
		SoundManager.getSound("popin_open").play();
		
		check++;
		if (check > 2) {
			for(button in levelButtons){
				button.once(MouseEventType.CLICK,onClick);
				button.once(TouchEventType.TAP, onClick);
			}
		}
	}
	/**
	 * fonction Callback des bouton de selection de niveau
	 * @author Marc-Olivier FALLA
	 */
	private function onClick (pEvent:EventTarget): Void {
		SoundManager.getSound("click").play();
		selectedLevel = pEvent.target.getName();
		GraphicLoader.isHelp = true;
		UIManager.getInstance().openScreen(GraphicLoader.getInstance());
		loadLevelAsset();
	}
	
	/**
	 * Chargement des Assets des Niveau en fonction du niveaux choisi
	 * @author Marc-Olivier FALLA
	 */
	private function loadLevelAsset(){
		var lLoader:GameLoader = new GameLoader();
		
		lLoader.addTxtFile(selectedLevel + ".json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/"+selectedLevel + "_assets.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/"+selectedLevel + "_bg1.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/"+selectedLevel + "_bg2.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/"+selectedLevel + "_bg3.json");
		lLoader.on(LoadEventType.PROGRESS, onLoadProgress);
		lLoader.once(LoadEventType.COMPLETE, onLoadComplete);
		lLoader.load();
	}
	
	/**
	 * transmet les paramètres de chargement au préchargeur graphique
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadProgress (pLoader:GameLoader): Void {
		GraphicLoader.getInstance().update(pLoader.progress/100);
	}
	
	/**
	 * initialisation du jeu
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadComplete (pLoader:GameLoader): Void {
		
		pLoader.off(LoadEventType.PROGRESS, onLoadProgress);
		if(Browser.getLocalStorage().getItem("selectedlevel")!=selectedLevel){
			StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+Browser.getLocalStorage().getItem("selectedlevel") + "_assets.json"));
			StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+Browser.getLocalStorage().getItem("selectedlevel") + "_bg1.json"));
			StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+Browser.getLocalStorage().getItem("selectedlevel") + "_bg2.json"));
			StateGraphic.clearTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+Browser.getLocalStorage().getItem("selectedlevel") + "_bg3.json"));
		}
		StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+selectedLevel+"_assets.json"));
		StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+selectedLevel+"_bg1.json"));
		StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+selectedLevel+"_bg2.json"));
		StateGraphic.addTextures(GameLoader.getContent(DeviceCapabilities.textureType+"/"+selectedLevel + "_bg3.json"));
		Browser.getLocalStorage().setItem("selectedlevel", selectedLevel);
		GameManager.getInstance().start();
	}

	/**
	 * Permet de trier de manière aléatoire un tableau
	 * @author Marc-Olivier FALLA
	 * @param pArray tableau de Boutons de selection de niveau
	 * @return mixed tableau de Bouton de selection de niveau
	 */
	private function randomArray(pArray:Array<ButtonUi>):Array<ButtonUi>{
		var length = pArray.length;
		var mixed:Array<ButtonUi> = pArray.slice(0, length);
		var rand:Int;
		var lastIndext:ButtonUi;
		for (i in 0...length){
			lastIndext = mixed[i];
			rand = Math.floor(Math.random() * length);
			mixed[i] = mixed[rand];
			mixed[rand] = lastIndext;
		}
		Browser.getLocalStorage().setItem("rand", "done");
		return mixed;
	}
	
	/**
	 * Permet de créer le tableau de boutons de selection de niveau 
	 * @author Marc-Olivier FALLA
	 * @return mixed tableau de Bouton de selection de niveau
	 */
	private function createButtonArray():Array<ButtonUi>{
		var buttonArray:Array<ButtonUi> = new Array<ButtonUi>();
		for (i in 0 ... NB_LEVELS){
			buttonArray.push(new ButtonUi("Level"+(i+1)));
			buttonArray[i].width = background.width / NB_LEVELS;
			buttonArray[i].height = background.height;
			collectibleWin = new Ui();
			switch i{
				case 0:
					collectibleWin.setModeCollectableJump();
					collectibleWin.alpha = (Browser.getLocalStorage().getItem("Jump") != null?1:0.5);
				case 1:
					collectibleWin.setModeCollectableShield();
					collectibleWin.alpha = (Browser.getLocalStorage().getItem("Shield") != null?1:0.5);
				case 2:
					collectibleWin.setModeCollectableShoot();
					collectibleWin.alpha = (Browser.getLocalStorage().getItem("Shoot") != null?1:0.5);
					
			}
			if (Browser.getLocalStorage().getItem(  buttonArray[i].getName()+ "score") != null && Browser.getLocalStorage().getItem(buttonArray[i].getName() + "maxscore") != null)
				buttonArray[i].setText(Browser.getLocalStorage().getItem(buttonArray[i].getName() + "score") + "/" + Browser.getLocalStorage().getItem(buttonArray[i].getName() + "maxscore"));
			else
				buttonArray[i].setText("???/???");
			collectibleWin.y = -background.height / 4;
			buttonArray[i].alpha = 0;
			buttonArray[i].addChild(collectibleWin);
			//buttonArray[i].setText("Level " + (i + 1));     
		}
		return buttonArray;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}
}