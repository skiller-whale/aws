# # TODO: Uncomment all the code in this file.

# # Gets the root domain for your learner account.
# data "aws_iam_account_alias" "current" {}
# data "aws_route53_zone" "main" {
#   name = join("", [trimprefix(data.aws_iam_account_alias.current.account_alias, "skw-"), local.domain])
# }

# # Creates a new Route 53 zone for the "staging" subdomain.
# resource "aws_route53_zone" "staging" {
#   name = "staging.${data.aws_route53_zone.main.name}"
# }

# # Adds an NS record to the main zone to delegate the "staging" subdomain to the new zone.
# resource "aws_route53_record" "staging" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = "staging.${data.aws_route53_zone.main.name}"
#   type    = "NS"
#   ttl     = "172800"
#   records = aws_route53_zone.staging.name_servers
# }

# # Creates an A record in the "staging" zone to point "blog." to the web load balancer using an alias.
# resource "aws_route53_record" "staging_blog" {
#   zone_id = aws_route53_zone.staging.zone_id
#   name    = "blog.${aws_route53_zone.staging.name}"
#   type    = "A"

#   alias {
#     name                   = aws_lb.web.dns_name
#     zone_id                = aws_lb.web.zone_id
#     evaluate_target_health = true
#   }
# }
