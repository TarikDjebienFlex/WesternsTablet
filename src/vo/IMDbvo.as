package vo {
	[RemoteClass]
	[Bindable]
	public class IMDbvo {
		
		public static function build(actors:String, director:String, genre:String, id:String, plot:String,
									 rating:String, runtime:String, title:String, year:String, writer:String = "", poster:String =
									 ""):IMDbvo{
			var imdbvo:IMDbvo=new IMDbvo();
			imdbvo.actors = actors;
			imdbvo.director = director;
			imdbvo.genre = genre;
			imdbvo.id = id;
			imdbvo.plot = plot;
			imdbvo.rating = Number(rating);
			imdbvo.runtime = runtime;
			imdbvo.us = title;
			imdbvo.year = year;
			
			imdbvo.writer = writer;
			imdbvo.poster = poster;
			
			return imdbvo;
		}
		
		public static function buildFromObject(o:Object):IMDbvo {
			var imdbvo:IMDbvo =  IMDbvo.build(o.Actors, o.Director, o.Genre, o.ID, o.Plot, o.Rating, o.
				Runtime, o.Title, o.Year, o.Writer, o.Poster);
			
			return imdbvo
		}
		
		public function IMDbvo() {
		}
		
		public var actors:String;
		public var director:String;
		public var genre:String;
		public var id:String;
		public var plot:String;
		public var poster:String;
		public var rating:Number;
		public var runtime:String;
		public var us:String;
		public var writer:String;
		public var year:String;
		
		public function toString():String {
			return us + ' ' + actors + ' ' + director + ' ' + genre + ' ' + id + ' ' + plot + ' ' + rating +
				' ' + runtime + ' ' + year + ' ' + writer + ' ' + poster;
		}
	}
}
