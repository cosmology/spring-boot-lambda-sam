
## SpringBoot 3 on Lambda

Example repository for running a [SpringBoot API](https://projects.spring.io/spring-boot/) on AWS Lambda . The `StreamLambdaHandler` object is the main entry point for Lambda.

## Pre-requisites
* [AWS CLI](https://aws.amazon.com/cli/)
* [SAM CLI](https://github.com/awslabs/aws-sam-cli)
* [Maven](https://maven.apache.org/)

## Deployment

In order to deploy the application code you need your AWS account profile setup

```bash
aws configure --profile local-profile
```

### Application

The application is deployed using AWS SAM. You can [install AWS SAM here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html). To deploy the application run the below commands:

```
sam build
sam deploy --guided
```
The application can be deployed in an AWS account using the [Serverless Application Model](https://github.com/awslabs/serverless-application-model). Check out `template.yml` file in the root folder for application definition.

## Run in Docker

* Install [Docker](https://docs.docker.com/desktop/) and run

```
docker compose up
```