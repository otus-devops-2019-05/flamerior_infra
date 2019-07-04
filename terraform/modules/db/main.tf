resource "google_compute_instance" "db" {
  name = "reddit-db"
  machine_type = "g1-small"
  zone = "${var.zone}"
  tags = ["reddit-db"]
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }
  network_interface {
    network = "${var.network}"
    network_ip = "${var.db_ip}"
  }
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
    startup-script ="${file("${path.module}/files/config_mongo.sh")}"
  }
}

