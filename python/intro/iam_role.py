import json

import boto3

# IAM Role

def create_iam_role():
    iam = boto3.client("iam")
    assume_role_policy_document = json.dumps({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
    })

    response = iam.create_role(
        RoleName = "LambdaExecuteRole",
        AssumeRolePolicyDocument = assume_role_policy_document
    )

    return response["Role"]["RoleName"]


# IAM Policy for S3 bucket access

def create_iam_policy():
    # Create IAM client
    iam = boto3.client('iam')
    
    # Create a policy
    my_managed_policy = { 
        "Version": "2012-10-17", 
        "Statement": [ 
            {
                "Effect": "Allow", 
                "Action": "s3:GetObject", 
                "Principal": "*", 
                "Resource": "arn:aws:s3:::jmlab20220919/*" 
            }, 
            { 
                "Effect": "Allow", 
                "Action": "s3:ListBucket", 
                "Principal": "*", 
                "Resource": "arn:aws:s3:::jmlab20220919" 
            } 
        ] 
    }   
    response = iam.create_policy(
        PolicyName='S3bucketAccessPolicy',
        PolicyDocument=json.dumps(my_managed_policy)
    )
    print(response)


# IAM User

def create_user(user_name):
    iam = boto3.client("iam")
    response = iam.create_user(UserName=user_name)
    print(response)

# # Attach Policy to user

# def attach_user_policy(policy_arn, user_name):
#     iam = boto3.client("iam")
#     response = iam.attach_user_policy(
#         UserName=user_name,
#         PolicyArn=policy_arn
#     )
#     print(response)

# Attach policy to role

def attach_iam_policy(policy_arn, role_name):
    iam = boto3.client("iam")
    response = iam.attach_role_policy(
        RoleName=role_name,
        PolicyArn=policy_arn
    )
    print(response)