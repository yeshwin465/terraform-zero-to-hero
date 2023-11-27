provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "<>:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "0fd7c61b-4dc4-4376-cc1f-2c9d7743129e"
      secret_id = "497c4471-5121-4528-a101-9a3169237a30"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "skv" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
