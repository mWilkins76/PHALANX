package com.isartdigital.utils.localize;
import com.isartdigital.utils.loader.GameLoader;
import haxe.xml.Fast;
import haxe.xml.Proxy;

/**
 * ...
 * @author Eimin
 */
class LocalizeText
{
	private static var LocalizedText:Map<String,String> = new Map<String,String>();
	private static var Xlf:Fast;
	private static var xmlFile:Xml;
	public function new() 
	{
		
	}
	public static function init():Void {
		xmlFile = GameLoader.getXml(Config.language+".xml");
		Xlf = new Fast(xmlFile.firstElement());
		
		var body = Xlf.node.file.node.body;
		var source:String;
		var translation:String;
		for (translate in body.nodes.resolve("trans-unit")){
			source = translate.node.source.innerHTML;
			translation = translate.node.target.innerHTML;
			LocalizedText.set(source, translation);
		}
	}
	/**
	 * permet de récupérer le texte localisé stocké
	 * @param	pString de type String le mot ou la phrase en anglais
	 * @return
	 */
	public static function useLocalizedtext(pString:String):String{
		
		return LocalizedText.get(pString);
	}
}