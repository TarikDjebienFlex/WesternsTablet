package bdd
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SyncEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import utils.Mobile;
	
	import vo.WesternVO;
	
	public class DBHelper
	{
		public static var sqlConnection:SQLConnection;

		public static function openDatabase(file:File):void
		{
			var newDB:Boolean=true;
			if (file.exists)
				newDB=false;
			sqlConnection=new SQLConnection();
			sqlConnection.open(file);
			if (newDB)
			{
				createDatabase();
				populateDatabase();
			}
		}

		protected static function createDatabase():void
		{
			var sql:String="CREATE TABLE IF NOT EXISTS western ( " + "id INTEGER PRIMARY KEY AUTOINCREMENT, " + "imagePoster BLOB,  " + "imageIcon BLOB,    " + "fr TEXT,  " + "us TEXT,  " + "year INTEGER,  " + "imageURL TEXT,  " + "description TEXT,  " + "director TEXT)";

			var stmt:SQLStatement=new SQLStatement();
			stmt.sqlConnection=sqlConnection;
			stmt.text=sql;
			try
			{
				stmt.execute();
			}
			catch (error:Error)
			{
				Mobile.alert("Problème d'exécution de la requête vers la BDD :" + error);
			}
		}

		protected static function populateDatabase():void
		{
			var file:File=File.applicationDirectory.resolvePath("data/westerns.xml");

			var fileOpened:Boolean=false;

			if (file.exists)
			{
				var stream:FileStream=new FileStream();
				try
				{
					stream.open(file, FileMode.READ);
					fileOpened=true;
				}
				catch (error:Error)
				{
					Mobile.alert("Problème pour retrouver westerns.xml :" + error);
				}

				if (fileOpened)
				{
					var xml:XML=XML(stream.readUTFBytes(stream.bytesAvailable));
					stream.close();

					var westernDAO:WesternDAO=new WesternDAO();
					for each (var item:XML in xml.western)
					{
						var western:WesternVO= WesternVO.build(item.@id, item.@fr, item.@us, item.@réalisateur, item.@année, item.@imageURL, item.description);
						westernDAO.create(western);
					}
				}
			}
		}
	}
}
