terraform {
  required_version = ">= 1.0.0"
  required_providers {
    local = {
        source = "hashicorp/local"
        version = ">= 2.0.0"
      }
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "local" {
    path = "state/terraform.tfstate"
  }
}

# provider "aws" {
#   region = "ap-northeast-3"
# }

# resource "local_file" "abc" {
#   content  = "abc!"
#   filename = "${path.module}/abc.txt"
# }
# resource "local_file" "abc" {
#   content  = "lifecycle - step 4"
#   filename = "${path.module}/abc.txt"
#   lifecycle {
#     # create_before_destroy = false
#     # prevent_destroy = true
#     ignore_changes = [
#       content
#     ]
#   }
# }

# resource "local_file" "def" {
#   depends_on = [ local_file.abc ]
#   content  = "def!"
#   filename = "${path.module}/def.txt"
# }

# resource "local_file" "def" {
#   content  = local_file.abc.content
#   filename = "${path.module}/def.txt"
# }

# resource "aws_instance" "web" {
#   ami = "ami-a1b2c3d4"
#   instance_type = "t3.micro"
# }

# variable "file_name" {
#   default = "step0.txt"
# }

# resource "local_file" "step6" {
#   content = "lifecycle - step 6"
#   filename = "${path.module}/${var.file_name}"

#   lifecycle {
#     precondition {
#       condition = var.file_name == "step6.txt"
#       error_message = "file name is not \"step6.txt\""
#     }
#   }
# }

# resource "local_file" "step7" {
#   content = ""
#   filename = "${path.module}/step7.txt"
#   lifecycle {
#     postcondition {
#       condition = self.content != ""
#       error_message = "content cannot empty"
#     }
#   }
# }

# output "step7_content" {
#   value = local_file.step7.id
# }

# data "local_file" "abc" {
#   filename = local_file.abc.filename
# }

# resource "local_file" "def" {
#   content = data.local_file.abc.content
#   filename = "${path.module}/def.txt"
# }

# variable "my_password" {}

# resource "local_file" "abc2" {
#   content = var.my_password
#   filename = "${path.module}/abc2.txt"
# }

# output "file_id" {
#   value = local_file.abc.id
# }

# output "file_abspath" {
#   value = abspath(local_file.abc.filename)
# }

# variable "names" {
#   type = list(string)
#   default = [ "a", "b", "c" ]
# }

# resource "local_file" "abc" {
#   count = length(var.names)
#   content = "abc-${count.index}"
#   filename = "abc-${var.names[count.index]}.txt"
# }

# resource "local_file" "def" {
#   count = length(var.names)
#   content = local_file.abc[count.index].content
#   filename = "def-${element(var.names, count.index)}.txt"
# }

# resource "local_file" "abc" {
#   for_each = {
#     a = "content a",
#     b = "content b"
#   }
#   content = each.value
#   filename = "${each.key}.txt"
# }

# variable "names" {
#   type = list(string)
#   default = [ "a", "b", "c" ]
# }

# output "A_upper_value" {
#   value = [for v in var.names: upper(v)]
# }

# output "B_index_and_value" {
#   value = [for i, v in var.names: "${i} is ${v}"]
# }

# output "C_make_object" {
#   value = {for v in var.names: v => upper(v)}
# }

# output "D_with_filter" {
#   value = [for v in var.names: upper(v) if v != "a"]
# }

# variable "members" {
#   type = map(object({
#     role = string
#   }))
#   default = {
#     "ab" = { role = "member", group = "dev" }
#     "cd" = { role = "admin", group = "dev" }
#     "ef" = { role = "member", group = "ops" }
#   }
# }

# output "A_to_tuple" {
#   value = [for k, v in var.members: "${k} is ${v.role}"]
# } 

# output "B_get_only_one" {
#   value = {
#     for name, user in var.members: name => user.role
#     if user.role == "admin"
#   }
# }

# output "C_group" {
#   value = {
#     for k, v in var.members: v.role => k...
#   }
# }

# data "archive_file" "dotfiles" {
#   type = "zip"
#   output_path = "${path.module}/dotfiles.zip"

#   source {
#     content = "hello a"
#     filename = "${path.module}/a.txt"
#   }
#   source {
#     content = "hello b"
#     filename = "${path.module}/b.txt"
#   }
#   source {
#     content = "hello c"
#     filename = "${path.module}/c.txt"
#   }
# }

# variable "names" {
#   default = {
#     a = "hello a"
#     b = "hello b"
#     c = "hello c"
#   }
# }

# data "archive_file" "dotfiles" {
#   type = "zip"
#   output_path = "${path.module}/dotfiles.zip"

#   dynamic "source" {
#     for_each = var.names
#     content {
#       content = source.value
#       filename = "${path.module}/${source.key}.txt"
#     }
#   }
# }

# variable "enable_file" {
#   default = false
#   # default = true
# }
# resource "local_file" "foo" {
#   count = var.enable_file ? 1 : 0
#   content = "foo!"
#   filename = "${path.module}/foo.bar"
# }

# output "content" {
#   value = var.enable_file ? local_file.foo[0].content:""
# }

# resource "local_file" "foo" {
#   content = upper("foo!")
#   filename = "foo.bar"
# }

# variable "sensitive_content" {
#   default = "secret"
#   sensitive = true
# }
# resource "local_file" "foo" {
#   content = upper(var.sensitive_content)
#   filename = "foo.bar"

#   provisioner "local-exec" {
#     command = "echo The content is ${self.content}"
#   }
#   provisioner "local-exec" {
#     command = "abc"
#     on_failure = continue
#   }
#   provisioner "local-exec" {
#     when = destroy
#     command = "echo The deleting filename is  ${self.filename}"
#   }
# }
# variable "username" {
#   type = string
# }
# variable "host" {
#   type = string
# }
# variable "password" {
#   type = string
# }
# variable "port" {
#   type = number
# }

# resource "null_resource" "example2" {
  # connection {
  #   type = "ssh"
  #   user = var.username
  #   password = var.password
  #   host = var.host
  #   port = var.port
  # }
  # provisioner "file" {
  #   source = "tfplan"
  #   destination = "~/tfplan"
  # }
  # provisioner "file" {
  #   content = "terraform file"
  #   destination = "~/tffile"
  # }

  # provisioner "remote-exec" {
  #   inline = [ 
  #     "echo 'Terraform!' > ~/tffile",
  #     "cat ~/tffile"
  #   ]
  # }
# }

# data "aws_ami" "amzn2" {
#   most_recent = true
#   owners = [ "amazon" ]
#   filter {
#     name = "owner-alias"
#     values = ["amazon"]
#   }
#   filter {
#     name = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }

# resource "aws_instance" "name" {
#   ami = data.aws_ami.amzn2.id
#   instance_type = "t3.micro"
#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }

module "mypw1" {
  source = "./modules/terraform-random-pwgen"
}

output "mypw1" {
  value = module.mypw1
}