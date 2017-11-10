package vo
{
	[Bindable]
	[RemoteClass]
	public class WesternVO
	{
		
		public function WesternVO()
		{
			
		}
		
		public var description:String;
		public var director:String;
		public var fr:String;
		
		public var id:String;
		public var imageURL:String;
		public var loaded:Boolean=false;
		public var us:String;
		public var year:int;
		private var _urlPath:String;
		
		public static function build(id:String, fr:String, us:String, director:String, year:int, imageURL:String, description:String):WesternVO{
			var w:WesternVO=new WesternVO();
			
			w.id=id;
			w.fr=fr;
			w.us=us;
			w.director=director;
			w.year=year;
			w.imageURL=imageURL;
			w.description=description;
			
			return w
		}
		
		public function get posterURL():String
		{
			var prefix:String="0";
			var i:int=0;
			var max:int=3 - id.length;
			
			for (i=0; i < max; i++)
			{
				prefix+="0";
			}
			
			_urlPath="data/affiches/" + prefix + id + ".jpg";
			return _urlPath;
		}
		
		public function toString():String
		{
			return id + ' ' + fr + ' ' + us + ' ' +director + ' ' +year + ' ' + imageURL + ' ' + description;
		}
	}
}