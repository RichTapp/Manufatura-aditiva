<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Web" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Clear();
        Response.ContentType = "text/plain";
        Response.ContentEncoding = Encoding.UTF8;

        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Response.Cache.SetExpires(DateTime.UtcNow.AddYears(-1));

        string pasta = Server.MapPath("~/App_Data");
        string arquivo = Path.Combine(pasta, "contador.txt");

        try
        {
            if (!Directory.Exists(pasta))
            {
                Directory.CreateDirectory(pasta);
            }

            bool contarVisita = true;

            // Verifica se este navegador já foi contado nos últimos 30 minutos
            HttpCookie cookie = Request.Cookies["MGA_Visita"];

            if (cookie != null)
            {
                DateTime ultimaVisita;

                if (DateTime.TryParse(
                    cookie.Value,
                    null,
                    System.Globalization.DateTimeStyles.RoundtripKind,
                    out ultimaVisita))
                {
                    TimeSpan intervalo = DateTime.Now - ultimaVisita;

                    if (intervalo.TotalMinutes < 30)
                    {
                        contarVisita = false;
                    }
                }
            }

            long total = 0;

            if (File.Exists(arquivo))
            {
                string conteudo = File.ReadAllText(
                    arquivo,
                    Encoding.UTF8
                ).Trim();

                long.TryParse(conteudo, out total);
            }

            // Só incrementa se for uma nova visita
            if (contarVisita)
            {
                lock (Application)
                {
                    // Lê novamente dentro do lock para evitar conflitos
                    if (File.Exists(arquivo))
                    {
                        string conteudo = File.ReadAllText(
                            arquivo,
                            Encoding.UTF8
                        ).Trim();

                        long.TryParse(conteudo, out total);
                    }

                    total++;

                    File.WriteAllText(
                        arquivo,
                        total.ToString(),
                        Encoding.UTF8
                    );
                }

                // Cria/atualiza o cookie da visita
                HttpCookie novoCookie = new HttpCookie(
                    "MGA_Visita",
                    DateTime.Now.ToString("o")
                );

                novoCookie.Expires = DateTime.Now.AddMinutes(30);
                novoCookie.HttpOnly = true;

                Response.Cookies.Add(novoCookie);
            }

            Response.Write(total.ToString());
        }
        catch
        {
            Response.StatusCode = 500;
            Response.Write("0");
        }

        Response.End();
    }
</script>