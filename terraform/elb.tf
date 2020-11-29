resource "aws_alb" "alb_front" {
	name		=	"front-alb"
	internal	=	false
	security_groups	=	["${aws_security_group.traffic-in.id}"]
	subnets		=	["${aws_subnet.public-1a.id}", "${aws_subnet.public-1b.id}"]
	enable_deletion_protection	=	true
}

# Target group

resource "aws_alb_target_group" "alb_front_https" {
	name	= "alb-front-https"
	vpc_id	= "${var.vpc_id}"
	port	= "443"
	protocol	= "HTTPS"
	health_check {
                path = "/healthcheck"
                port = "80"
                protocol = "HTTP"
                healthy_threshold = 2
                unhealthy_threshold = 2
                interval = 5
                timeout = 4
                matcher = "200-308"
        }
}

# Assign EC2 instances to the target group

resource "aws_alb_target_group_attachment" "alb_backend-01" {
  target_group_arn = "${aws_alb_target_group.alb_front_https.arn}"
  target_id        = "${aws_instance.backend-01.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "alb_backend-02" {
  target_group_arn = "${aws_alb_target_group.alb_front_https.arn}"
  target_id        = "${aws_instance.backend-01.id}"
  port             = 80
}

#Assign SSL certificates for https

resource "aws_alb_listener" "alb_front_https" {
	load_balancer_arn	=	"${aws_alb.alb_front.arn}"
	port			=	"443"
	protocol		=	"HTTPS"
	ssl_policy		=	"ELBSecurityPolicy-2016-08"
	certificate_arn		=	"${aws_iam_server_certificate.url1_valouille_fr.arn}"

	default_action {
		target_group_arn	=	"${aws_alb_target_group.alb_front_https.arn}"
		type			=	"forward"
	}
}

