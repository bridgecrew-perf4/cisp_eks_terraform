##
## Collect KMS Customer Master Key
##
data "aws_kms_key" "k8s_cmk" {
  key_id = "alias/k8s-cmk"
}

##
## Encrypted User and Password
##
data "aws_kms_secrets" "creds" {
  secret {
    name = "creds"
    payload = file(format("%s/%s",path.module,"pass.yaml.encrypt"))
  }
}


locals {
  creds = yamldecode(data.aws_kms_secrets.creds.plaintext["creds"])
}

