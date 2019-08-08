using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using DatabaseMigration.MySql;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MySql.Data.MySqlClient;

namespace DatabaseMigration.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MySqlController : ControllerBase
    {

        private readonly IConfiguration _configuration;

        public MySqlController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("SelectAllTables/{password}")]
        public IActionResult SelectAllTables(string password)
        {
            if (password.Equals(_configuration["ConnectionStrings:PasswordToAccess"]))
            {

                string connectionString = _configuration["ConnectionStrings:OKRCoachDB"];
                string schemaToLoad = _configuration["ConnectionStrings:SchemaToLoad"];
                string schemaToInsert = _configuration["ConnectionStrings:SchemaToInsert"];

                try
                {
                    var objetos = MySqlOperations.SelectAll(connectionString, schemaToLoad);
                    return Ok(objetos);
                }
                catch (Exception e)
                {
                    string error = e.InnerException.Message;

                    Console.WriteLine("IOException source: {0}", error);
                    return BadRequest(error);
                }
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpGet("SelectAllTablesToInsertInMySql/{password}")]
        public IActionResult SelectAllTablesToInsertInMySql(string password)
        {
            if (password.Equals(_configuration["ConnectionStrings:PasswordToAccess"]))
            {
                string connectionString = _configuration["ConnectionStrings:OKRCoachDB"];
                string schemaToLoad = _configuration["ConnectionStrings:SchemaToLoad"];
                string schemaToInsert = _configuration["ConnectionStrings:SchemaToInsert"];

                try
                {
                    var lines = MySqlOperations.SelectAllTablesToInsertInMySql(connectionString, schemaToLoad, schemaToInsert);
                    byte[] linesAsBytes = lines.SelectMany(s => Encoding.ASCII.GetBytes(s)).ToArray();
                    return File(linesAsBytes, "application/sql", $"Dump_{schemaToLoad}.sql");
                }
                catch (Exception e)
                {
                    string error = e.InnerException.Message;

                    Console.WriteLine("IOException source: {0}", error);
                    return BadRequest(error);
                }
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpGet("SelectTableToInsertInMySql/{table}/{password}")]
        public IActionResult SelectTableToInsertInMySql(string table, string password)
        {
            if (password.Equals(_configuration["ConnectionStrings:PasswordToAccess"]))
            {
                string connectionString = _configuration["ConnectionStrings:OKRCoachDB"];
                string schemaToLoad = _configuration["ConnectionStrings:SchemaToLoad"];
                string schemaToInsert = _configuration["ConnectionStrings:SchemaToInsert"];

                try
                {
                    MySqlOperations.SelectTableToInsertInMySql(connectionString, schemaToLoad, schemaToInsert, table);
                    return Ok();
                }
                catch (Exception e)
                {
                    string error = e.InnerException.Message;

                    Console.WriteLine("IOException source: {0}", error);
                    return BadRequest(error);
                }
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpGet("SelectAllTablesToInsertInMySqlIntoMT")]
        public IActionResult SelectAllTablesToInsertInMT()
        {
            string connectionString = _configuration["ConnectionStrings:OKRCoachDB"];
            string schemaToLoad = _configuration["ConnectionStrings:SchemaToLoad"];
            string schemaToInsert = _configuration["ConnectionStrings:SchemaToInsert"];

            try
            {
                var lines = MySqlOperations.SelectAllTablesToInsertInMySqlIntoMT(connectionString, schemaToLoad, schemaToInsert);
                byte[] linesAsBytes = lines.SelectMany(s => Encoding.UTF8.GetBytes(s)).ToArray();
                return File(linesAsBytes, "application/sql", $"Dump_{schemaToLoad}.sql");
            }
            catch (Exception e)
            {
                string error = e.InnerException.Message;

                Console.WriteLine("IOException source: {0}", error);
                return BadRequest(error);
            }
        }

        [HttpPost("ReadAllInserts")]
        public async System.Threading.Tasks.Task<IActionResult> ReadAllInsertsAsync(IFormFile file)
        {

            var result = new StringBuilder();
            using (var reader = new StreamReader(file.OpenReadStream()))
            {
                while (reader.Peek() >= 0)
                    result.AppendLine(await reader.ReadLineAsync());
            }

            var lines = result.ToString().Split(';');
            List<string> inserts = new List<string>();
            List<string> noInserts = new List<string>();

            foreach (var line in lines)
            {
                if (line.StartsWith("INSERT") || line.StartsWith(" INSERT")
                    || line.StartsWith("\nINSERT") || line.StartsWith("\n\nINSERT"))
                {
                    inserts.Add($"{line};");
                }
                else
                {
                    noInserts.Add(line);
                }
            }

            //using (MySqlConnection connection = new MySqlConnection("server=database;port=3306;userid=OKRSystem;password=8YrPMdge2UY;database=OKR_COACH_MT;"))
            using (MySqlConnection connection = new MySqlConnection(_configuration["ConnectionStrings:OKRCoachDB"]))
            {
                foreach (var insert in inserts)
                {
                    MySqlCommand command = new MySqlCommand($"{insert}", connection);
                    try
                    {
                        command.Connection.Open();
                        command.ExecuteNonQuery();
                        command.Connection.Close();
                    }
                    catch
                    {
                        command.Connection.Close();
                    }
                }
            }
            return Ok();
        }

    }
}