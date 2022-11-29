###### EFS CONFIG ######

# Creating EFS file system
resource "aws_efs_file_system" "efs" {
  depends_on     = [var.ec2_instance]
  creation_token = "my-efs"
  tags = {
    Name = "MyProduct"
  }
}

### EFS MOUNT TARGET ###

resource "aws_efs_mount_target" "mount" {
  depends_on      = [aws_efs_file_system.efs]
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.ec2_instance_subnet_id
  security_groups = [var.security_group_id]
}

### EFS MOUNT POINT ###

resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.mount]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.private_key
    host        = var.ec2_public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir ~/efs-mount-point",
      "sudo yum install nfs-utils -y -q ",
      # Mount EFS
      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  ~/efs-mount-point",
      # Making Mount Permanent
      "cd ~/efs-mount-point",
      "sudo chmod go+rw ~/efs-mount-point"
    ]
  }
}