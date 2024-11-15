#!/bin/bash

echo
echo "Initializing LocalStack"
echo "using avaialable: awslocal"
echo "instead of: aws --endpoint-url=http://localhost:4566"
echo "======================="

echo
echo "Installing jq"
echo "-------------"
apt-get -y install jq

echo
echo "Creating news-topic in SNS"
echo "--------------------------"
awslocal sns create-topic --name news-topic

echo
echo "Creating news-consumer-queue in SQS"
echo "-----------------------------------"
awslocal sqs create-queue --queue-name news-consumer-queue

echo
echo "Subscribing news-consumer-queue to news-topic"
echo "---------------------------------------------"
awslocal sns subscribe \
  --topic-arn arn:aws:sns:eu-west-1:000000000000:news-topic \
  --protocol sqs \
  --attributes '{"RawMessageDelivery":"true"}' \
  --notification-endpoint arn:aws:sqs:eu-west-1:000000000000:news-consumer-queue

echo
echo "Creating news table in DynamoDB"
echo "-------------------------------"
awslocal dynamodb create-table \
  --table-name news \
  --attribute-definitions AttributeName=id,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES

echo
echo "Getting news table DynamoDB Stream ARN"
echo "--------------------------------------"
NEWS_TABLE_DYNAMODB_STREAM_ARN=$(awslocal dynamodb describe-table --table-name news | jq -r '.Table.LatestStreamArn')
echo "NEWS_TABLE_DYNAMODB_STREAM_ARN=${NEWS_TABLE_DYNAMODB_STREAM_ARN}"

echo
echo "Creating Lambda Function called ProcessDynamoDBEvent"
echo "----------------------------------------------------"
awslocal lambda create-function \
  --function-name ProcessDynamoDBEvent \
  --runtime java21 \
  --memory-size 512 \
  --handler org.springframework.cloud.function.adapter.aws.FunctionInvoker::handleRequest \
  --zip-file fileb:///shared/dynamodb-lambda-function-java21-aws.jar \
  --environment "Variables={AWS_REGION=eu-west-1,AWS_ACCESS_KEY_ID=key,AWS_SECRET_ACCESS_KEY=secret}" \
  --role arn:aws:iam::000000000000:role/service-role/irrelevant \
  --timeout 60

echo
echo "Creating a mapping between news table DynamoDB event source and ProcessDynamoDBEvent lambda function"
echo "----------------------------------------------------------------------------------------------------"
awslocal lambda create-event-source-mapping \
  --function-name ProcessDynamoDBEvent \
  --event-source $NEWS_TABLE_DYNAMODB_STREAM_ARN \
  --starting-position LATEST

echo
echo "Listing dynamodb tables"
echo "==================================="
awslocal dynamodb list-tables
echo

echo
echo "LocalStack initialized successfully"
echo "==================================="
echo