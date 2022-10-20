import os

import boto3 # AWS SDK

# EC2 Instances
# DO NOT run all at once

def create_key_pair(region):
    try:
        region = str(region)
        ec2_client = boto3.client("ec2", region_name=region)
        key_pair = ec2_client.create_key_pair(KeyName="ec2-key-pair")

        private_key = key_pair["KeyMaterial"]

        # write private key to file with 400 permissions
        with os.fdopen(os.open("./aws_ec2_key.pem", os.O_WRONLY | os.O_CREAT, 0o400), "w+") as handle:
            handle.write(private_key)
    except:
        print("Please enter a valid region.")


def create_instance(ami_id, key_name):
    try:
        ami_id = str(ami_id)
        key_name = str(key_name)
        ec2_client = boto3.client("ec2", region_name="us-east-1")
        instances = ec2_client.run_instances(ImageId=ami_id, MinCount=1, MaxCount=1, InstanceType="t2.micro", KeyName=key_name)

        print(instances["Instances"][0]["InstanceId"])
    except:
        print("Not a valid AMI ID or key not found.")

def get_running_instances(region):
    try:
        region = str(region)
        ec2_client = boto3.client("ec2", region_name=region)
        reservations = ec2_client.describe_instances(Filters=[
            {
                "Name": "instance-state-name",
                "Values": ["running"],
            }
        ]).get("Reservations")

        for reservation in reservations:
            for instance in reservation["Instances"]:
                instance_id = instance["InstanceId"]
                instance_type = instance["InstanceType"]
                public_ip = instance["PublicIpAddress"]
                private_ip = instance["PrivateIpAddress"]
                print(f"Running instance in {region} = {instance_id} as {instance_type},\n Public IP = {public_ip}, \n Private IP = {private_ip}")
    except: 
        print('Not a valid region')


def terminate_instance(instance_id, region):
    try:
        region = str(region)
        ec2_client = boto3.client("ec2", region_name=region)
        response = ec2_client.terminate_instances(InstanceIds=[instance_id])
        print(response)
    except:
        print('Please enter a valid instance id or region.')


# IAM