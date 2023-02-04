package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs"
)

var (
	bucket = os.Getenv("BUCKET")

	client *cloudwatchlogs.Client
)

func init() {
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	client = cloudwatchlogs.NewFromConfig(cfg)
}

func main() {
	lambda.Start(createExportTask)
}

type createExportRequest struct {
	LogGroup string `json:"log_group"`
	Prefix   string `json:"prefix"`
	From     int64  `json:"from"`
	To       int64  `json:"to"`
}

type createExportResponse struct {
	TaskID string `json:"task_id"`
}

func createExportTask(ctx context.Context, req createExportRequest) (createExportResponse, error) {
	input := &cloudwatchlogs.CreateExportTaskInput{
		LogGroupName:      &req.LogGroup,
		Destination:       &bucket,
		DestinationPrefix: &req.Prefix,
		From:              &req.From,
		To:                &req.To,
	}

	output, err := client.CreateExportTask(ctx, input)
	if err != nil {
		return createExportResponse{}, fmt.Errorf("error creating export task: %v", err)
	}

	return createExportResponse{
		TaskID: *output.TaskId,
	}, nil
}
