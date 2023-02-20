# locals {
#   config-map-aws-auth = <<CONFIGMAPAWSAUTH
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: aws-auth
#   namespace: kube-system
# data:
#   mapRoles: |
#     - rolearn: ${aws_iam_role.eks-worker-role.arn}
#       username: system:node:{{EC2PrivateDNSName}}
#       groups:
#         - system:bootstrappers
#         - system:nodes
# CONFIGMAPAWSAUTH

#   kubeconfig = <<KUBECONFIG
# apiVersion: v1
# clusters:
# - cluster:
#     server: ${aws_eks_cluster.eks.endpoint}
#     certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
#   name: kubernetes
# contexts:
# - context:
#     cluster: kubernetes
#     user: aws
#   name: aws
# current-context: aws
# kind: Config
# preferences: {}
# users:
# - name: aws
#   user:
#     exec:
#       apiVersion: client.authentication.k8s.io/v1alpha1
#       command: heptio-authenticator-aws
#       args:
#         - "token"
#         - "-i"
#         - "${local.eks_cluster_name}"
# KUBECONFIG
# }

# output "config-map-aws-auth" {
#   value = local.config-map-aws-auth
# }

# output "kubeconfig" {
#   value = local.kubeconfig
# }

#output "private_ip" {
#  description = "The private IP address assigned to the instance."
#  value       = aws_instance.terraform-testing.private_ip
#}