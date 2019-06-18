using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DatabaseMigration.MySql;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

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
    }
}