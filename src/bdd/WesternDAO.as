package bdd
{
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import mx.collections.ArrayCollection;
	import utils.Mobile;
	import vo.WesternVO;
	
	public class WesternDAO
	{

		public function WesternDAO()
		{
			// BDD locale recréée automatiquement
			DBHelper.openDatabase(File.documentsDirectory.resolvePath("Westerns.db"));
		}

		public function create(western:WesternVO):void
		{
			trace(western.fr);
			if (!DBHelper.sqlConnection)
				return;

			var sql:String="INSERT INTO western (id, description, director, fr, imageURL, us, year) " + "VALUES (?,?,?,?,?,?,?)";

			var stmt:SQLStatement=new SQLStatement();
			stmt.sqlConnection=DBHelper.sqlConnection;
			stmt.text=sql;
			stmt.parameters[0]=western.id;
			stmt.parameters[1]=western.description;
			stmt.parameters[2]=western.director;
			stmt.parameters[3]=western.fr;
			stmt.parameters[4]=western.imageURL;
			stmt.parameters[5]=western.us;
			stmt.parameters[6]=western.year;

			try
			{
				stmt.execute();
				western.loaded=true;
			}
			catch (error:Error)
			{
				Mobile.alert( "Problème d'exécution de la requête vers la BDD :" + error);
			}
		}

		public function findByTitle(searchKey:String, orderBy:String="year"):ArrayCollection
		{
			if (!DBHelper.sqlConnection)
				return null;

			if (searchKey == "Western Name")
				searchKey="";

			var sql:String="SELECT * FROM western WHERE fr || ' ' || us LIKE '%" + searchKey + "%' ORDER BY " + orderBy;
			var stmt:SQLStatement=new SQLStatement();
			stmt.sqlConnection=DBHelper.sqlConnection;
			stmt.text=sql;
			var result:Array;
			try
			{
				stmt.execute();
				result=stmt.getResult().data;
			}
			catch (error:Error)
			{
				Mobile.alert("Problème d'exécution de la requête vers la BDD :" + error);
			}

			if (result)
			{
				var list:ArrayCollection=new ArrayCollection();
				for (var i:int=0; i < result.length; i++)
				{
					list.addItem(processRow(result[i]));
				}
				return list;
			}
			else
			{
				return null;
			}
		}

		public function getItem(id:int):WesternVO
		{
			if (!DBHelper.sqlConnection)
				return null;

			var sql:String="SELECT id, fr, us, year, imageURL, description, director FROM western WHERE id=?";
			var stmt:SQLStatement=new SQLStatement();
			stmt.sqlConnection=DBHelper.sqlConnection;
			stmt.text=sql;
			stmt.parameters[0]=id;

			var result:Array;
			try
			{
				stmt.execute();
				result=stmt.getResult().data;
			}
			catch (error:Error)
			{
				Mobile.alert("Problème d'exécution de la requête vers la BDD :" + error);
			}

			if (result && result.length == 1)
				return processRow(result[0]);
			else
				return null;
		}


		protected function processRow(o:Object):WesternVO
		{
			var item:Object=new Object();
			item.id=o.id;
			item.fr=o.fr == null ? "" : o.fr;
			item.us=o.us == null ? "" : o.us;
			item.year=Number(o.year == null ? "" : o.year);
			item.imageURL=o.imageURL == null ? "" : o.imageURL;
			item.description=o.description == null ? "" : o.description;
			item.director=o.director == null ? "" : o.director;

			var western:WesternVO=WesternVO.build(item.id, item.fr, item.us, item.director, item.year, item.imageURL, item.description);
			western.loaded=true;
			return western;
		}
	}
}
