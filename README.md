# genomics-eng-tech-challenge

This code was created following [the Genomics England technical challenge brief](https://c.smartrecruiters.com/sr-company-attachments-prod-dc5/5eb39856e897e940ef25db3f/bd498af2-f725-4b3a-976a-3d4eb052212e?r=s3-eu-central-1)

To run the code do the following:

1. Configure your backend file located [here](./config/dev/backend.tfbackend) by editing the `bucket` value to match a value of a bucket in your account
1. Build the lambda layer files for linux using the command below:
    ```sh
    pip install --platform manylinux2014_x86_64 --target=./resources/layer/python/lib/python3.12/site-packages --implementation cp --python-version "3.12" --only-binary=:all: -r ./resources/requirements/requirements-layer.txt --upgrade
    ```
1. Initialise terraform by running `terraform init --backend-config=./config/dev/backend.tfbackend`
1. Run a terraform plan using `terraform plan --var-file=./config/dev/variables.tfvars`
1. Apply the terraform configuration using `terraform apply --var-file=./config/dev/variables.tfvars`
    - The terraform configuration can be destroyed using `terraform destroy --var-file=./config/dev/variables.tfvars`

# Architectural considerations

As mentioned previously, this terraform was created as per a technical challenge brief. However, other than that the details were relatively light to allow for developer freedom.

This lack of limitations is both a blessing and a curse in terms of deciding the architecture. As such the terraform contained in this repo aims to strike a balance between the requirements, good enough, and production ready.

## Additional improvements

Some of the policies in this code aren't what I would consider production ready. E.g. the [kms policy](./modules/kms/main.tf) delegates usage to IAM for expediency when developing. If this code were to be productionised, this would need to be changed to have a least privillege policy.

The lambda also consumes events directly from the default event bus. There are some potential drawbacks from this. Mainly, the lambda could reach maximum concurrent executions and drop events. In a high throughput scenario, eventbridge invocation throttle limits could be breached. To solve both, an SQS queue or SNS + SQS combination could provide better queueing of events. Additionally, in this code an eventbridge DLQ has not been set, meaning that events with no destination are dropped with no observability. Fixing the above would be worth considering.

The lambda function is written in python, whilst this is good for quick development, a compiled language such as golang would be better for handling this task quicker.

Lambda is also not the only way to solve this task, other options I would have liked to explore would be writing the application in a docker container and deploying it to ECS or EKS.

Tests should be written for the python code to validate the function locally bypassing the need to do a manual acceptance test of the lambda function. You can view the [requirements-dev.txt](./resources/requirements/requirements-dev.txt) to get an idea of what packages would have been used in testing if I had the time left to write them (primarily, moto, with pytest).

Whilst the usecase states that JPEG images are the only ones that will be handled by the application, you could also extend the code to add more strict validation (pydantic model for events, regexes for file extensions).

## The good points

Using a lambda layer allowed me to bring Pillow into the lambda runtime without building a container from scratch.

Using a CMK allowed me to encrypt the lambda environment variables and logs.

My test case using [this test image](./resources/scripts/exif_remover/tests/images/Canon_40D.jpg) worked.