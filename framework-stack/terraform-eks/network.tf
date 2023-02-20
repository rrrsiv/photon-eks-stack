############## VPC ###################################
# Already created via Ansible as part of initial setup

################## Internet Gateway ######################
# Already created via Ansible as part of initial setup

################## SUBNET ######################

resource "aws_subnet" "public-subnet-1a" {
  cidr_block        = local.public_subnet_1a
  vpc_id            = "${local.vpc_id}"
  tags              = {
    Name = "${local.project}-${local.env}-subnet1"
  }
  availability_zone = "${local.region}a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-subnet-1b" {
  cidr_block        = local.public_subnet_1b
  vpc_id            = "${local.vpc_id}"
  tags              = {
    Name = "${local.project}-${local.env}-subnet2"
  }
  availability_zone = "${local.region}b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnet-1a" {
  cidr_block        = local.private_subnet_1a
  vpc_id            = "${local.vpc_id}"
  tags              = {
    Name = "${local.project}-${local.env}-pvt-sub-1"
    "kubernetes.io/cluster/perf-test_photon_eks_cluster" = "owned"
  }
  availability_zone = "${local.region}a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private-subnet-1b" {
  cidr_block        = local.private_subnet_1b
  vpc_id            = "${local.vpc_id}"
  tags              = {
    Name = "${local.project}-${local.env}-pvt-sub-2"
    "kubernetes.io/cluster/perf-test_photon_eks_cluster" = "owned"
  }
  availability_zone = "${local.region}b"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private-subnet-1c" {
  cidr_block        = local.private_subnet_1c
  vpc_id            = "${local.vpc_id}"
  tags              = {
    Name = "${local.project}-${local.env}-pvt-sub-3"
    "kubernetes.io/cluster/perf-test_photon_eks_cluster" = "owned"
  }
  availability_zone = "${local.region}c"
  map_public_ip_on_launch = false
}

############### Security Group ###############

resource "aws_security_group" "eks-cluster-sg" {
  name        = "${local.env}-${local.project}-eks-cluster-sg"
  description = "SG For EKS Cluster"
  vpc_id      = "${local.vpc_id}"
  tags        = {
    Name = "${local.project}-${local.env}-eks-cluster-sg"
    "kubernetes.io/cluster/perf-test_photon_eks_cluster" = "owned"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow pods to communicate with the cluster API Server"
    cidr_blocks = ["${local.vpc_ipblock}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    description = "Allow all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [ingress, egress]
  }
}


resource "aws_security_group" "eks-worker-node-sg" {
  name        = "${local.env}-${local.project}-eks-worker-node-sg"
  description = "EKS worker node security group"
  vpc_id      = "${local.vpc_id}"
  tags        = {
    Name = "${local.project}-${local.env}-eks-worker-node-sg"
    "kubernetes.io/cluster/perf-test_photon_eks_cluster" = "owned"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    description = "Allow all traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    description = "Allow all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

############### Security Group ###############

############### NAT Gateway ###############

# elastic IP for natgw
resource "aws_eip" "eip" {
  vpc  = true
  tags = {
    Name = "${local.project}-${local.env}-eip"
  }
  //  lifecycle {
  //    prevent_destroy = true
  //  }
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-1a.id
  tags          = {
    Name = "${local.project}-${local.env}-nat"
  }
  //  lifecycle {
  //    prevent_destroy = true
  //  }
}

############### Route Table ###############

resource "aws_route_table" "public-route-table" {
  vpc_id = "${local.vpc_id}"
  tags   = {
    Name = "${local.project}-${local.env}-pub-RT"
  }
  //  lifecycle {
  //    prevent_destroy = true
  //  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = "${local.vpc_id}"
  tags   = {
    Name = "${local.project}-${local.env}-pvt-RT"
  }
  //  lifecycle {
  //    prevent_destroy = true
  //  }
}

resource "aws_route" "public-route-table-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${local.gateway_id}"
}

resource "aws_route" "route-with-ngw" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "public-subnet-1a" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1a.id
}

resource "aws_route_table_association" "public-subnet-1b" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1b.id
}


resource "aws_route_table_association" "private-subnet-1a" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1a.id
}

resource "aws_route_table_association" "private-subnet-1b" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1b.id
}

resource "aws_route_table_association" "private-subnet-1c" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1c.id
}