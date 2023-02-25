resource "vercel_project" "apricote_de" {
  name = "apricote-de"

  framework     = "hugo"
  build_command = "hugo -D --gc -b https://$${SITE_URL:-$VERCEL_URL}"

  git_repository = {
    type = "github"
    repo = "apricote/apricote.de"
  }
}

# Override the VERCEL_URL for production deployment, used as Hugo base domain,
# see "build_command" above.
resource "vercel_project_environment_variable" "apricote_de_site_url" {
  project_id = vercel_project.apricote_de.id
  key        = "SITE_URL"
  value      = vercel_project_domain.apricote_de.domain
  target     = ["production"]
}

resource "vercel_project_environment_variable" "apricote_de_listory_token" {
  project_id = vercel_project.apricote_de.id
  key        = "HUGO_LISTORY_TOKEN"
  value      = var.listory_token
  target     = ["production", "preview", "development"]
}

resource "vercel_project_environment_variable" "apricote_de_listory_host" {
  project_id = vercel_project.apricote_de.id
  key        = "HUGO_LISTORY_HOST"
  value      = "https://listory.apricote.de/api/"
  target     = ["production", "preview", "development"]
}

resource "vercel_project_domain" "apricote_de" {
  project_id = vercel_project.apricote_de.id
  domain     = "apricote.de"
}

# Redirect www. to @
resource "vercel_project_domain" "www_apricote_de" {
  project_id = vercel_project.apricote_de.id
  domain     = "www.${vercel_project_domain.apricote_de.domain}"

  redirect             = vercel_project_domain.apricote_de.domain
  redirect_status_code = 308
}

resource "hetznerdns_record" "apricote_de_a" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "@"
  value   = "76.76.21.21" # TODO: Get value from vercel provider
  type    = "A"
  ttl     = 60
}

resource "hetznerdns_record" "www_apricote_de" {
  zone_id = hetznerdns_zone.apricote_de.id
  name    = "www"
  value   = "cname.vercel-dns.com." # TODO: Get value from vercel provider
  type    = "CNAME"
  ttl     = 60
}
