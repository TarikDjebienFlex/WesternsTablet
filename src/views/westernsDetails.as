import flash.events.Event;
import flash.events.TransformGestureEvent;

import mx.events.FlexEvent;

import spark.events.ViewNavigatorEvent;
import spark.transitions.SlideViewTransitionMode;
import spark.transitions.ViewTransitionDirection;
import spark.transitions.ZoomViewTransitionMode;

import views.WesternsIMDbDetails;
import views.WesternsPoster;

import vo.WesternVO;
import vo.WesternsCollection;

[Bindable]
private var _movie:WesternVO;
[Bindable]
private var _moviesCollection:WesternsCollection;

/**
 * Chargement des données en restauration de vue 
 * @param event
 * 
 */
private function dataChangeHandler(event:FlexEvent):void
{
	if(this.data){
		_moviesCollection=this.data as WesternsCollection;
		_movie=_moviesCollection.getCurrentMovie();
	}
}

/**
 * effectue la navigation dans la collection 
 * @param navigation
 * 
 */
private function doNavigate(navigation:int):void{
	var navigate:Boolean=false;
	
	if(navigation>0){
		navigate=(_moviesCollection.currentItem!=_moviesCollection.arrayCollection.length);
		_slideViewTransition.direction=ViewTransitionDirection.LEFT;
	}
	else{
		navigate=(_moviesCollection.currentItem!=0);
		_slideViewTransition.direction=ViewTransitionDirection.RIGHT;
	}
	
	if(navigate){
		_moviesCollection.currentItem=_moviesCollection.currentItem+navigation;
		
		if(false){
			this.navigator.popToFirstView();// éviter l'empilement des vues
			this.navigator.pushView(WesternsDetails,_moviesCollection,null,_slideViewTransition);
		}
		else{// replaceView est plus élégant dans ce cas
			this.navigator.replaceView(WesternsDetails,_moviesCollection,null,_slideViewTransition);
		}
		
	}
}

/**
 * navgation vers film suivant 
 * 
 */
private function goNext():void{
	doNavigate(1);
}

/**
 * navigation vers film précédent 
 * 
 */
private function goPrev():void{
	doNavigate(-1);
}

/**
 * navigation vers IMDB 
 * @param event
 * 
 */
private function imdbIcon_clickHandler(event:Event):void
{
	var context:String="detail";
	this.navigator.pushView(WesternsIMDbDetails,_movie,context);// _fadeTransition
	
}

/**
 * gestion du swipe pour naviguer en avant et en arrière dans la collection 
 * @param event
 * 
 */
private function swipeHandler(event:TransformGestureEvent):void {
	// si la propriété offsetX = -1 => swipe vers la gauche 
	// si la propriété offsetX = 1 => swipe vers la droite
	if(event.offsetX == -1) {
		goNext();
	} else 
		if(event.offsetX == 1) {
			goPrev();
		}
	
	// même chose pour le swipe vertical non pris en compte ici
	if(event.offsetY == -1) {
		//goPrev();
	} else 
		if(event.offsetY == 1) {
			//goNext();
		}
}

/**
 * initialisation de la vue 
 * @param event
 * 
 */
private function viewActivateHandler(event:ViewNavigatorEvent):void
{
}

/**
 * affichage de l'affiche du film dans une nouvelle vue 
 * @param event
 * 
 */
private function details_displayPosterHandler(event:Event):void
{
	this.navigator.pushView(WesternsPoster,_movie,null,_zoomTransition )
}