terraform {
  # Версия terraform
  required_version = ">0.11,<0.12"
  backend "gcs" {
    bucket  = "storage-bucket-prod"
    prefix  = "terraform/state"
  }
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  app_disk_image = "${var.app_disk_image}"
  db_address = "${module.vpc.db_ip}"
  network="${module.vpc.my_net}"
  private_key = "${file(var.private_key_path)}"
  autodeploy = "false"
  app_ip = "${module.vpc.app_ip}"
}

module "db" {
  source = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  db_disk_image = "${var.db_disk_image}"
  network="${module.vpc.my_net}"
  private_key = "${file(var.private_key_path)}"
  db_ip = "${module.vpc.db_ip}"
}

module "vpc" {
  source = "../modules/vpc"
  source_ranges = "${var.source_ranges}"
  app_ip = "${module.app.app_internal_ip}"
  region        = "${var.region}"

}
