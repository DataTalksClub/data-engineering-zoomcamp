# load_balancer.tf | Load Balancer Configuration

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "google_compute_security_policy" "policy" {
  name = "${var.app_name}-security-policy"

  rule {
    action   = "allow"
    priority = "100"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["${chomp(data.http.myip.response_body)}/32"]
      }
    }
    description = "Whitelist IP"
  }

  # Uncomment the example rule below to whitelist IPs for specific endpoints.
  # rule {
  #   action   = "allow"
  #   priority = "200"
  #   match {
  #     expr {
  #       # https://cloud.google.com/armor/docs/rules-language-reference
  #       expression = "request.path.startsWith('/api/pipeline_schedules/100/pipeline_runs') && inIpRange(origin.ip, '1.1.1.1/32')"
  #     }
  #   }
  #   description = "Whitelist IP for specific endpoints"
  # }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "${var.app_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.run_service.name
  }
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 6.3"
  name    = "${var.app_name}-urlmap"
  project = var.project_id

  ssl                             = var.ssl
  managed_ssl_certificate_domains = [var.domain]
  https_redirect                  = var.ssl
  labels                          = { "example-label" = "cloud-run-example" }

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.cloudrun_neg.id
        }
      ]
      enable_cdn              = false
      security_policy         = google_compute_security_policy.policy.name
      custom_request_headers  = null
      custom_response_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}

# -----------------------------------------------------------------------------
# Create load balancer resources for DBT docs server, uncomment if needed

# resource "google_compute_global_address" "docs_ip" {
#   name = "${var.app_name}-service-docs-ip"
# }

# resource "google_compute_region_network_endpoint_group" "cloudrun_docs_neg" {
#   name                  = "${var.app_name}-docs-neg"
#   network_endpoint_type = "SERVERLESS"
#   region                = var.region
#   cloud_run {
#     service = google_cloud_run_service.dbt_docs_service.name
#   }
# }

# resource "google_compute_backend_service" "docs_backend" {
#   name      = "${var.app_name}-docs-backend"

#   protocol  = "HTTP"
#   port_name = "http"
#   timeout_sec = 30

#   backend {
#     group = google_compute_region_network_endpoint_group.cloudrun_docs_neg.id
#   }

#   security_policy = google_compute_security_policy.policy.name
# }

# resource "google_compute_url_map" "docs_url_map" {
#   name            = "${var.app_name}-docs-urlmap"

#   default_service = google_compute_backend_service.docs_backend.id
# }

# resource "google_compute_target_http_proxy" "docs_http_proxy" {
#   name    = "${var.app_name}-docs-http-proxy"
#   url_map = google_compute_url_map.docs_url_map.id
# }

# resource "google_compute_global_forwarding_rule" "docs_frontend" {
#   name       = "${var.app_name}-docs-frontend"
#   target     = google_compute_target_http_proxy.docs_http_proxy.id
#   port_range = "80"
#   ip_address = google_compute_global_address.docs_ip.address
# }
