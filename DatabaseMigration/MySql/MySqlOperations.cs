using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.Linq;
using System.Text;

namespace DatabaseMigration.MySql
{
    public class MySqlOperations
    {
        public static HashSet<HashSet<IDictionary<string, object>>> SelectAll(string connectionString, string schema)
        {
            HashSet<HashSet<IDictionary<string, object>>> list = new HashSet<HashSet<IDictionary<string, object>>>();
            HashSet<string> tables = GetAllTableName(connectionString, schema);
            foreach (var table in tables)
            {
                list.Add(SelectObjectsFromTable(connectionString, schema, table));
            }
            return list;
        }

        public static List<string> SelectAllTablesToInsertInMySql(string connectionString, string schemaToLoad, string schemaToInsert)
        {
            List<string> linhas = new List<string>();
            HashSet<string> mainTables = new HashSet<string>(new string[] { "Image", "Company", "AspNetRoles",
                "CellUnit", "Team", "AspNetUsers", "Objective", "KeyResult" });
            HashSet<string> tables = GetAllTableName(connectionString, schemaToLoad);

            foreach (var table in mainTables)
            {
                HashSet<IDictionary<string, object>> objetos = SelectObjectsFromTable(connectionString, schemaToLoad, table);
                foreach (var objeto in objetos)
                {
                    linhas.Add(InsertInto(objeto, schemaToInsert, table));
                }
            }

            foreach (var table in tables)
            {
                HashSet<IDictionary<string, object>> objetos = SelectObjectsFromTable(connectionString, schemaToLoad, table);
                foreach (var objeto in objetos)
                {
                    linhas.Add(InsertInto(objeto, schemaToInsert, table));
                }
            }
            return linhas;
        }

        public static List<string> SelectTableToInsertInMySql(string connectionString, string schemaToLoad, string schemaToInsert, string table)
        {
            List<string> linhas = new List<string>();
            HashSet<IDictionary<string, object>> objetos = SelectObjectsFromTable(connectionString, schemaToLoad, table);

            foreach (var objeto in objetos)
            {
                linhas.Add(InsertInto(objeto, schemaToInsert, table));
            }
            return linhas;
        }

        private static HashSet<string> GetAllTableName(string connectionString, string schema)
        {
            string queryString = $"SELECT table_name FROM information_schema.tables WHERE table_schema ='{schema}';";
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(queryString, connection);
                MySqlDataReader reader = command.ExecuteReader();

                HashSet<string> list = new HashSet<string>();

                while (reader.Read())
                {
                    var names = Enumerable.Range(0, reader.FieldCount).Select(reader.GetName).ToList();

                    foreach (IDataRecord record in reader)
                    {
                        var expando = new ExpandoObject();
                        foreach (var name in names)
                        {
                            if (!IsMainTable(record[name] as string))
                                list.Add(record[name] as string);
                        }
                    }
                }

                return list;
            }
        }

        private static HashSet<IDictionary<string, object>> SelectObjectsFromTable(string connectionString, string schema, string table)
        {
            HashSet<IDictionary<string, object>> list = new HashSet<IDictionary<string, object>>();
            string queryString = $"SELECT * FROM `{schema}`.{table};";
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                connection.Open();

                MySqlCommand command = new MySqlCommand(queryString, connection);
                MySqlDataReader reader = command.ExecuteReader();

                do
                {
                    {
                        var names = Enumerable.Range(0, reader.FieldCount).Select(reader.GetName).ToList();

                        foreach (IDataRecord record in reader)
                        {
                            var expando = new ExpandoObject() as IDictionary<string, object>;
                            foreach (var name in names)
                                expando[name] = record[name];
                            list.Add(expando);
                        }
                    }
                }
                while (reader.Read());

            }

            if (table.Equals("OKR"))
            {
                HashSet<IDictionary<string, object>> listOfOKRs = new HashSet<IDictionary<string, object>>();
                while (list.Count != 0)
                {
                    foreach (var okr in list)
                    {
                        var okrToFind = okr;
                        var okrBackup = okrToFind;

                        while (okrToFind != null)
                        {
                            okrBackup = okrToFind;
                            okrToFind = RecursiveFindOKRInList(list, okrToFind);
                        }

                        listOfOKRs.Add(okrBackup);
                        list.Remove(okrBackup);

                        break;
                    }
                }
                list = listOfOKRs;
            }

            return list;
        }

        private static string InsertInto(IDictionary<string, object> objeto, string schema, string table)
        {
            string linha = $"INSERT INTO `{schema}`.`{table}` (";
            // 02/ 01/2019 -> 2019-01-02 00:00:00
            for (int i = 0; i < objeto.Count; i++)
            {
                linha += $"`{objeto.Keys.ElementAt(i).ToString()}`";
                if (i < objeto.Count - 1)
                    linha += ",";
            }
            linha += ") VALUES (";

            for (int j = 0; j < objeto.Count; j++)
            {
                string[] format = new string[] { "dd/MM/yyyy HH:mm:ss" };
                DateTime datetime;

                if (objeto.Values.ElementAt(j).ToString() == "")
                {
                    linha += "NULL";
                }
                else if (objeto.Values.ElementAt(j).ToString().Equals("0") || objeto.Values.ElementAt(j).ToString().Equals("1"))
                {
                    linha += $"{objeto.Values.ElementAt(j).ToString()}";
                }
                else if (DateTime.TryParseExact(objeto.Values.ElementAt(j).ToString(), format,
                    System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.NoCurrentDateDefault, out datetime))
                {
                    linha += $"'{datetime.Year}-{datetime.Month}-{datetime.Day} 00:00:00'";
                }
                else
                {
                    linha += $"'{objeto.Values.ElementAt(j).ToString().Replace(',', '.')}'";
                }
                if (j < objeto.Count - 1)
                    linha += ",";
            }
            linha += ");";

            return linha;
        }

        private static bool IsMainTable(string tableName)
        {
            if (tableName.Equals("Image") || tableName.Equals("AspNetRoles") || tableName.Equals("CellUnit") || tableName.Equals("KeyResult")
                || tableName.Equals("Company") || tableName.Equals("Team") || tableName.Equals("AspNetUsers") || tableName.Equals("Objective"))
            {
                return true;
            }
            return false;
        }

        private static IDictionary<string, object> IterateInOKRs(HashSet<IDictionary<string, object>> list)
        {
            foreach (var okrLv0 in list)
            {
                foreach (var okrLv1 in list)
                {
                    if (okrLv1.Values.ElementAt(0).ToString().Equals(okrLv0.Values.ElementAt(5).ToString()))
                    {
                        foreach (var okrLv2 in list)
                        {
                            if (okrLv2.Values.ElementAt(0).ToString().Equals(okrLv1.Values.ElementAt(5).ToString()))
                            {
                                foreach (var okrLv3 in list)
                                {
                                    bool iterateAllLv3 = true;
                                    if (okrLv3.Values.ElementAt(0).ToString().Equals(okrLv2.Values.ElementAt(5).ToString()))
                                    {
                                        iterateAllLv3 = false;
                                        return okrLv3;
                                    }

                                    if (iterateAllLv3)
                                    {
                                        return okrLv2;
                                    }
                                }
                            }
                        }
                        return okrLv1;
                    }
                }
                return okrLv0;
            }
            return null;
        }

        private static IDictionary<string, object> RecursiveFindOKRInList(HashSet<IDictionary<string, object>> list, IDictionary<string, object> okrToFind)
        {

            foreach (var okr in list)
            {
                if (okr.Values.ElementAt(0).ToString().Equals(okrToFind.Values.ElementAt(5).ToString()))
                    return okr;
            }
            return null;
        }
    }
}