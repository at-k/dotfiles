locals {
  stages = ["dev", "staging", "prod"]
}

locals {
  hoge = "b"
}

resource null_resource "null_resource" {
  for_each = toset(local.stages)
  name     = "${each.key} hoge"
  triggers = {
    stage = local.stages[each.key]
  }
  provisioner "local-exec" {
    command = "echo ${local.stages[each.key]}"
  }
}
