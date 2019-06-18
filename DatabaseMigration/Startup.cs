using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Swashbuckle.AspNetCore.Swagger;
using System.Collections.Generic;

namespace DatabaseMigration
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IHostingEnvironment hostingEnvironment)
        {
            Configuration = configuration;

            var builder = new ConfigurationBuilder()
                               .SetBasePath(hostingEnvironment.ContentRootPath)
                               .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                               .AddJsonFile($"appsettings.{hostingEnvironment.EnvironmentName}.json", reloadOnChange: true, optional: true)
                               .AddEnvironmentVariables();

            Configuration = builder.Build();
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSwaggerGen
                (c =>
                {
                    c.SwaggerDoc("v1", new Info { Title = Configuration["Info:Title"], Version = Configuration["Info:Version"] });
                    var security = new Dictionary<string, IEnumerable<string>>
                    {
                    {"Bearer", new string[] { }},
                    };

                    c.AddSecurityDefinition("Bearer", new ApiKeyScheme
                    {
                        Description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
                        Name = "Authorization",
                        In = "header",
                        Type = "apiKey"
                    });
                    c.AddSecurityRequirement(security);
                });

            services.AddCors();

            services.AddCors(o => o.AddPolicy("MyPolicy", builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader();
            }));

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2)
                .AddJsonOptions(opcoes =>
                {
                    opcoes.SerializerSettings.NullValueHandling =
                        Newtonsoft.Json.NullValueHandling.Ignore;
                });

            services.AddHttpClient();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseCors("MyPolicy");
            app.UseStaticFiles();
            app.UseCors(builder => builder
                  .AllowAnyOrigin()
                  .AllowAnyMethod()
                  .AllowAnyHeader());

            app.UseAuthentication();

            ConfigureSwagger(app, env);



            app.UseMvc();
            app.UseHttpsRedirection();
        }

        private void ConfigureSwagger(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseStaticFiles();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "V1 Docs"));
            }

            app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "V1 Docs"));
            app.UseSwagger();

        }
    }
}
