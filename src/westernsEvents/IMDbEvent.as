package westernsEvents
{
	import flash.events.Event;
	
	import vo.IMDbvo;
	
	/**
	 * événement émis lors de la réception de la réponse à une requête vers IMDBAPI
	 * véhicule un objet IMDbvo correspondant au résultat JSON
	 * @author ckeromen
	 * 
	 */	
	public class IMDbEvent extends Event
	{
		public var imdbvo:IMDbvo;
		
		public function IMDbEvent(type:String, imbdvo:IMDbvo)
		{
			super(type);
			this.imdbvo=imbdvo;
		}
		
		override public function clone():Event
		{
			return new IMDbEvent(type, imdbvo);
		}
	}
}