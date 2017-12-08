package com.isartdigital.utils.loader;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.sounds.SoundDef;
import com.isartdigital.utils.sounds.SoundManager;
import haxe.Json;
import howler.Howl;
import howler.Howler;
import js.html.XMLSerializer;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import pixi.loaders.ResourceLoader;
import webfont.WebFontLoader;

/**
 * Classe de chargement
 * Cette classe permet de gérer des chargements par lot aussi bien de fichiers textes que de ressources graphiques ou du son
 * @author Mathieu ANTHOINE
 */
class GameLoader extends Loader
{

	/**
	 * liste des fichiers sons à charger
	 */
	private var soundsList:Array<String>;
	
	private var soundsSpecs:Map<String,HowlOptions>;
	
	/**
	 * liste des fichiers chargés
	 */
	private static var txtLoaded:Map<String,Dynamic> = new Map<String,Dynamic>();
	
	/**
	* retourne le contenu chargé pour le chemin de fichier passé en paramètre
	* @param	pFile chemin du fichier
	* @return	ressource (JSon ou Xml)
	*/
	public static function getContent (pFile:String):Dynamic {
		return txtLoaded[Config.txtsPath+pFile];
	}
	/**
	* retourne le contenu chargé pour le chemin de fichier passé en paramètre
	* @param	pFile chemin du fichier
	* @return	ressource (JSon ou Xml)
	*/
	public static function getXml (pFile:String):Dynamic {
		return txtLoaded[Config.langPath+pFile];
	}
	
	public function new() 
	{
		soundsList = [];
		soundsSpecs = new Map();
		super();
		once(LoadEventType.COMPLETE, onComplete);

	}

	/**
	* ajoute un fichier de type texte à la liste de chargement (JSon ou Xml)
	* @param	pUrl chaine de caractères spécifiant le chemin vers le fichier
	*/
	public function addTxtFile (pUrl:String):Void {
		var lUrl:String = Config.txtsPath + pUrl;
		add(Config.url(lUrl));
	}	
	/**
	* ajoute un fichier de type texte à la liste de chargement (JSon ou Xml)
	* @param	pUrl chaine de caractères spécifiant le chemin vers le fichier
	*/
	public function addXmlFile (pUrl:String):Void {
		var lUrl:String = Config.langPath + pUrl;
		add(Config.url(lUrl));
	}	
	
	/**
	* ajoute un fichier d'assets à la liste de chargement
	* @param	pUrl chaine de caractère spécifiant le nom du fichier
	*/
	public function addAssetFile (pUrl:String):Void {	
		var lUrl:String = Config.assetsPath + pUrl;
		add(Config.url(lUrl));		
	}

	/**
	* ajoute une liste de sons à la liste de chargement
	* @param	pUrl chaine de caractère spécifiant le nom du fichier
	*/
	public function addSoundFile (pUrl:String):Void {	
		var lUrl:String = Config.soundsPath + pUrl;
		soundsList.push(lUrl);
		add(Config.url(lUrl));
	}	
	
	/**
	* ajoute un fichier css de polices de caractère
	* @param	pUrl chaine de caractère spécifiant le nom du fichier
	*/
	public function addFontFile (pUrl:String):Void {	
		var lUrl:String = Config.fontsPath + pUrl;
		add(Config.url(lUrl));		
	}
	
	private function parseData (pResource:Resource, pNext:Void->Void): Void {
		
		var lUrl:String = pResource.url.split("?")[0];
		
		if (lUrl.indexOf(".css") > 0) {
			
			var lData:Array<String> = pResource.data.split(";");
			var lFamilies:Array<String> = [];
			var lReg:EReg = ~/font-family:\s?(.*)/; 
			
			for (i in 0...lData.length) {
				if (lReg.match(lData[i])) lFamilies.push(lReg.matched(1));
			}
			
			var lWebFontConfig = {
				custom: {
					families: lFamilies,
					urls: [Config.fontsPath+"fonts.css"],
				},

				active: pNext
			};
		   
			WebFontLoader.load(lWebFontConfig);			
			return;
		}
		
		if (pResource.isJson) {
			
			txtLoaded[lUrl] = pResource.data;
			
			if (soundsList.length>0) { 
			
				var lData:SoundDef;
				
				for (i in 0...soundsList.length) {
					if (lUrl == soundsList[i]) {
						
						soundsList.splice(i, 1);
						
						lData = pResource.data;
					
						for (j in 0...lData.extensions.length) {
							if (Howler.codecs(lData.extensions[j])) {
								addSounds(lData.fxs,false,lData.extensions,lData.extensions[i]);
								addSounds(lData.musics,true,lData.extensions,lData.extensions[i]);
								break;
							}
						}
						break;
					}
				}
			
			}
			
		} else if (pResource.isXml) txtLoaded[lUrl] = Xml.parse(new XMLSerializer().serializeToString(pResource.data));
		
		pNext();
	}
	
	private function manageCache (pResource:Resource, pNext:Void->Void): Void {
		if  (pResource.name != pResource.url) pResource.url = Config.url(pResource.url);
		pNext();
	}
	
	private function addSounds (pList:Dynamic, pLoop:Bool, pExtensions:Array<String>, pCodec:String): Void {	
		var lUrl:String;
		for (lID in Reflect.fields(pList)) {
			lUrl = Config.url(Config.soundsPath + lID + "." + pCodec);
			soundsSpecs.set(lID, {urls:[lUrl],volume:Reflect.field(pList, lID) / 100, loop:pLoop} );
			add(lUrl);
		}
	}

	override public function load (?cb:Void -> Void):ResourceLoader {
		before(manageCache);
		after(parseData);
		return super.load();
	}
	
	private function onComplete ():Void {
		for (lID in soundsSpecs.keys()) {
			SoundManager.addSound(lID, new Howl (soundsSpecs[lID]));
		}
	}
	
}