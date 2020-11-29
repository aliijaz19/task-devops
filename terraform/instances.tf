resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+GmzMxZgBzis180Rz7tOi3w7JFNy1aVSOVgxRmV34R8ibCpcPWfgJ5ilO082dKgp2bh+ol8IxCBdSL4KpUFIQD/rGJ0Fw8xk9hd1n82iVDroF8y73w5m9AkRK9hAzA6eDR+U8sY8ckCbpx2fOs89PLap7xkZ+bPeOmWqMMr8nyd4z/COqg1NewYFdFjQWFANfOnwb8Lzo/wkm9gJ/ZNKQZfa2mJfwX3EgS9ioiaSlYQbPx0cCEp2oM+xjCgp0KFUjahC46tFxclHjWzQ3piByBm5cO/S121lerst/yRnibG3+Yvc/5c8EKW7Kp3RteKqeGC2363/PEViBpE4sqyEr k@laptop"
}


resource "aws_instance" "my_servers1" {
	count = "${length(var.subnets_cidr)}" 
	ami = "${var.webservers_ami}"
	instance_type = "${var.instance_type}"
	security_groups = ["${aws_security_group.webservers.id}"]
	subnet_id = "${element(aws_subnet.public.*.id,count.index)}"
	key_name = "${aws_key_pair.terraform-demo.key_name}"
	tags {
	  Name = "Server-${count.index}"
	}
}

resource "aws_instance" "my_servers2" {
        count = "${length(var.subnets_cidr)}"
        ami = "${var.webservers_ami}"
        instance_type = "${var.instance_type}"
        security_groups = ["${aws_security_group.webservers.id}"]
        subnet_id = "${element(aws_subnet.public.*.id,count.index)}"
	key_name = "${aws_key_pair.terraform-demo.key_name}"
        tags {
          Name = "Server-${count.index}"
        }
}