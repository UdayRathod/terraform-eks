resource "aws_security_group" "eks_worker_node_sg" {
  name_prefix = "eks-node-sg"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "worker_node_ingress" {
  description       = "allow inbound traffic from eks"
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  security_group_id = aws_security_group.eks_worker_node_sg.id
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/16"]
}

resource "aws_security_group_rule" "worker_node_egress" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks_worker_node_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]

}