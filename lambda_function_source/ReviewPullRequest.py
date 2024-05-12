import json
import boto3
from botocore.exceptions import ClientError 

def lambda_handler(event, context):
    # Extract information from the CodeCommit event
    pull_request_id = event['detail']['pullRequestId']
    repository_name = event['detail']['repositoryNames'][0]

    # Describe the pull request
    codecommit_client = boto3.client('codecommit')
    response = codecommit_client.get_pull_request(pullRequestId=pull_request_id)
    pull_request_description = response['pullRequest']['description']

    # Interact with Bedrock Claude 3 Sonnet model
    runtime_client = boto3.client(
        service_name="bedrock-runtime",
        region_name="us-east-1",
    )

    claude3_model_id = "anthropic.claude-3-sonnet-20240229-v1:0"

    def claude3(prompt):
        body = json.dumps(
            {
                "messages": [
                    {"role": "user", "content": [{"type": "text", "text": f"{prompt}"}]}
                ],
                "max_tokens": 1000,
                "temperature": 0.5,
                "top_k": 250,
                "top_p": 0.7,
                "anthropic_version": "bedrock-2023-05-31",
            }
        )

        response = runtime_client.invoke_model(body=body, modelId=claude3_model_id)

        response_body = json.loads(response.get("body").read())
        output_text = "".join([content["text"] for content in response_body.get("content", [])])
        return output_text

    # Prepare the prompt for the Sonnet model
    prompt = f"You are an AI assistant reviewing code changes in a pull request. Please provide your insights and feedback on the following pull request description:\n\n{pull_request_description}"

    # Call the Sonnet model using claude3 function
    review_text = claude3(prompt)

    # Add comment to the pull request
    try:
        response = codecommit_client.post_comment_for_pull_request(
            pullRequestId=pull_request_id,
            repositoryName=repository_name,
            beforeCommitId = response['pullRequest']['pullRequestTargets'][0]['sourceCommit'],            
            afterCommitId = response['pullRequest']['pullRequestTargets'][0]['destinationCommit'],
            content=review_text
        )
        print(f"Comment added to pull request ID {pull_request_id}")
    except ClientError as error:
        print(f"Error adding comment: {error}")

    # Return a response (optional)
    return {
        'statusCode': 200,
        'body': json.dumps('Pull request review initiated. Review text: ' + review_text)
    }