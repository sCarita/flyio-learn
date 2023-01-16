
export TOKEN := $(fly auth token)

login-fly:
	export FLY_API_TOKEN=${TOKEN};

pipe-fly:
	flyctl machines api-proxy;

terraform-init:
	terraform init

terraform-apply:
	terraform apply

terraform-destroy:
	terraform destroy
