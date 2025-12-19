module "network" {
  source   = "./modules/network"
  region   = var.region
  allow_ip = var.my_ip_allow
  project  = var.project
}

module "compute" {
  source         = "./modules/compute"
  region         = var.region
  healthcheck_id = module.loadbalancer.healthcheck_id
  project        = var.project
  zone           = var.zone
  vpc_id         = module.network.vpc_id
  subnet         = module.network.subnet
}

module "loadbalancer" {
  source             = "./modules/loadbalancer"
  igm_instance_grp   = module.compute.igm_instance_grp
  vpc_id             = module.network.vpc_id
  project            = var.project
  security_policy_id = module.network.security_policy_id
}