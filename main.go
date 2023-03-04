package main

import (
	"context"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs"
	"golang.org/x/exp/slog"
)

const (
	duration   = 24 * time.Hour
	timeFormat = "2006-01-02"
)

var (
	bucket   = os.Getenv("BUCKET")
	logGroup = os.Getenv("LOG_GROUP")

	client *cloudwatchlogs.Client
)

func init() {
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		slog.Error("Failed to load config", err)
		os.Exit(1)
	}

	client = cloudwatchlogs.NewFromConfig(cfg)
}

func main() {
	lambda.Start(triggerExport)
}

func triggerExport(ctx context.Context, event events.CloudWatchEvent) error {
	endTime := event.Time.Truncate(duration)
	startTime := endTime.Add(-duration)

	prefix := fmt.Sprintf("%s/%s", strings.TrimLeft(logGroup, "/"), startTime.Format(timeFormat))
	from := startTime.UnixMilli()
	to := endTime.UnixMilli()

	input := &cloudwatchlogs.CreateExportTaskInput{
		LogGroupName:      &logGroup,
		Destination:       &bucket,
		DestinationPrefix: &prefix,
		From:              &from,
		To:                &to,
	}

	slog.Info(
		"Creating export task",
		slog.String("log_group_name", logGroup),
		slog.String("destination", bucket),
		slog.String("destination_prefix", prefix),
		slog.Int64("from", from),
		slog.Int64("to", to),
	)

	output, err := client.CreateExportTask(ctx, input)
	if err != nil {
		return fmt.Errorf("error creating export task: %v", err)
	}

	slog.Info("Created export task", slog.String("task_id", *output.TaskId))
	return nil
}
