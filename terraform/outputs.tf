output "external_ip" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip}"
}

output "lb_ip" {
  value = "${google_compute_global_address.lb-global-ip.address}"
}
