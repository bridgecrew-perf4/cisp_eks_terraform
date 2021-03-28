
data "aws_route53_zone" "private" {
  name = var.r53_domain
  private_zone = true
  vpc_id = var.vpc_id
}

##
## Domain for Apps database (MariaDB)
##
resource "aws_route53_record" "mysql" {
  zone_id = data.aws_route53_zone.private.zone_id
  name = format("%s.%s",var.r53_mariadb_host,data.aws_route53_zone.private.name)
  type = "CNAME"
  ttl = "300"
  records = [aws_db_instance.apps.address]
}

##
## Domain for GW-API Kong database (PostgreSQL)
##
resource "aws_route53_record" "postgresql" {
  zone_id = data.aws_route53_zone.private.zone_id
  name = format("%s.%s",var.r53_postgresql_host,data.aws_route53_zone.private.name)
  type = "CNAME"
  ttl = "300"
  records = [aws_db_instance.api.address]
}
