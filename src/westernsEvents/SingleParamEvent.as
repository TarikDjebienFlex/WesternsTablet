package westernsEvents
{
	import flash.events.Event;

	// Une classe spécifique étend la classe de base flash.events.Event.
	public class SingleParamEvent extends Event
	{
		// la classe définit une variable publique pour transporter une donnée
		public var text:String;

		// le constructeur attend un paramètre permettant de fixer cette donnée
		public function SingleParamEvent(type:String, text:String)
		{
			// le constructeur appelle la méthode constructeur de la classe mère
			super(type);
			// puis renseigne la variable interne
			this.text=text;
		}

		// enfin, il est obligatoire pour le bon fonctionnement
		// de surcharger la méthode clone
		override public function clone():Event
		{
			// cette méthode retourne simplement un objet créé par le constructeur
			return new SingleParamEvent(type, text);
		}

	}
}
