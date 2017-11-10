import bdd.DBHelper;

import flash.filesystem.File;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

import spark.transitions.SlideViewTransition;
import spark.transitions.SlideViewTransitionMode;
import spark.transitions.ViewTransitionDirection;

import utils.Mobile;

import views.WesternsDetails;
import views.WesternsDetailsTabletLandscape;

import vo.WesternsCollection;

import westernsEvents.SingleParamEvent;
import westernsEvents.WesternsCollectionChange;

public static const WESTERNS_COLLECTION_CHANGE_ITEM:String="westernsCollectionChangeItem";
private static const WESTERNS_DB_NAME:String="Westerns.db";
public static const WESTERNS_SEARCH_FILMS:String="westernsSearchFilms";

[Bindable]
public var scaleFactor:Number=1;// redimensionnement dépendant de la résolution

private var _slideViewTransitionPop:SlideViewTransition=new SlideViewTransition();
private var _westernsCollection:WesternsCollection;
/**
 * Initialisation de l'application 
 * Ouverture de la BDD SQLite
 */
private function init():void{
	// BDD locale recréée automatiquement
	DBHelper.openDatabase(File.documentsDirectory.resolvePath(WESTERNS_DB_NAME));
	
	// evenements spécifiques émis par les vues au travers du navigator
	this.navigator.addEventListener(WESTERNS_SEARCH_FILMS,searchFilmsHandler);
	this.navigator.addEventListener(WESTERNS_COLLECTION_CHANGE_ITEM,selectFilmHandler);
	
	// non nécessaire, mode par défaut, pour mémoire
	Multitouch.inputMode = MultitouchInputMode.GESTURE;
	
	// Trace de differentes infos sur la resolution/définition d'écran
	Mobile.traceDPI();
	Mobile.traceResolution();
	
	setViewTransitions(); // paramétrage des transitions entre vues
}

/**
 * paramétrage des transitions entre vues
 *
 */
private function setViewTransitions():void
{	
	_slideViewTransitionPop.direction=ViewTransitionDirection.DOWN;
	_slideViewTransitionPop.mode=SlideViewTransitionMode.UNCOVER;
	_slideViewTransitionPop.easer=bounceEasing;
	
	this.navigator.defaultPushTransition=_slideViewTransitionPush;
	this.navigator.defaultPopTransition=_slideViewTransitionPop;
	
}

private function searchFilmsHandler(event:SingleParamEvent):void
{
	// en position 0 la chaine à rechercher, en position 1 le critère de tri
	if (event.text)
	{
		var args:Array=event.text.split(" ");
		searchFilms(args[0],args[1]);
	}
}

/**
 * Appelle la BDD pour effectuer une recherche/Titre et un tri
 * @param movieKey:String
 * @param sort:String
 *
 */
private function searchFilms(movieTitle:String="", sort:String="year"):void
{
	var ac:ArrayCollection=westernsDB.findByTitle(movieTitle, sort);
	if (!ac)
	{ // juste un exemple d'appel du composant d'affichage d'alerte
		Mobile.alert("Pas de films dans la sélection.");
	}
	
	_westernsCollection= WesternsCollection.build(ac, 0);
	
	var e:WesternsCollectionChange=new WesternsCollectionChange(WesternsCollectionChange.WESTERNS_COLLECTION_CHANGE_ARRAY,_westernsCollection);
	this.dispatchEvent(e);
}

private function selectFilmHandler(event:SingleParamEvent):void{
	if (event.text)
	{
		_westernsCollection.currentItem=Number(event.text);
		
		if (Mobile.isTablet())
		{
			this.navigator.pushView(WesternsDetailsTabletLandscape, _westernsCollection);
		}
		else
		{
			this.navigator.pushView(WesternsDetails, _westernsCollection);
		}
	}
}

private function navigatorStateLoadingHandler(event:FlexEvent):void
{
	_westernsCollection=this.persistenceManager.getProperty("wc") as WesternsCollection;
	
}

private function navigatorStateSavingHandler(event:FlexEvent):void
{
	this.persistenceManager.setProperty("wc",_westernsCollection);
}