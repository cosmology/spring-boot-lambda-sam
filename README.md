
## SpringBoot 3 on Lambda

Example repository for running a [SpringBoot API](https://projects.spring.io/spring-boot/) on AWS Lambda . The `StreamLambdaHandler` object is the main entry point for Lambda.

## Pre-requisites
* [Java 21+](https://www.oracle.com/java/technologies/downloads/#java21)
* [Maven](https://maven.apache.org/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [SAM CLI](https://github.com/awslabs/aws-sam-cli)

## Deployment

In order to deploy the application code you need your AWS account profile setup

```bash
aws configure --profile local-profile
```

### Application

The application is deployed using AWS SAM and uses CloudFormation underneath. You can [install AWS SAM here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html). To deploy the application run the below commands:

```
sam build
sam deploy --guided
```
The application can be deployed in an AWS account using the [Serverless Application Model](https://github.com/awslabs/serverless-application-model). Check out `template.yml` file in the root folder for application definition.

## Local Testing

[LocalStack](https://docs.localstack.cloud/overview/) emulates AWS services locally preventing us of incurring actual AWS usage costs. To initialize LocalStack and all the configuration among the AWS Cloud services we are going to run, local-aws-infrastructure.sh script is mounted through init hook to setup local infrastructure for dev and testing purposes.

* Install [Docker Desktop](https://docs.docker.com/desktop/) and run

```
docker compose up
```

## Shutdown

```
docker compose down -v
```

## Cleanup

* Go to AWS CloudFormation and delete the created stack in the SAM deployment.