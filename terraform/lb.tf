resource "google_compute_instance_group" "app-cluster" {
  name = "app-cluster"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "app-port"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_target_tcp_proxy" "app-target-tcp-proxy" {
  name            = "app-lb-proxy"
  backend_service = "${google_compute_backend_service.app-backend.self_link}"
}

resource "google_compute_global_address" "lb-global-ip" {
  name = "app-load-balancer-ip"
}

resource "google_compute_global_forwarding_rule" "app-global-forwarding-rule" {
  name       = "app-global-forwarding-rule"
  port_range = "195"

  ip_address = "${google_compute_global_address.lb-global-ip.address}"
  target     = "${google_compute_target_tcp_proxy.app-target-tcp-proxy.self_link}"
}

resource "google_compute_backend_service" "app-backend" {
  name             = "app-backend"
  protocol         = "TCP"
  port_name        = "app-port"
  timeout_sec      = 10
  session_affinity = "NONE"
  health_checks    = ["${google_compute_health_check.default-healthcheck.self_link}"]

  backend {
    group = "${google_compute_instance_group.app-cluster.self_link}"
  }
}

resource "google_compute_health_check" "default-healthcheck" {
  name               = "healthcheck"
  check_interval_sec = 10
  timeout_sec        = 10

  tcp_health_check {
    port = "9292"
  }
}
