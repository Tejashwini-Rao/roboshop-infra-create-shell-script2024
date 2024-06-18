##### Change these values ###
ZONE_ID="Z00593593U4GYH63O0YNE"
SG_NAME="Allow-All"
ENV="dev"
###################


create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
      --image-id ${AMI_ID} \
      --instance-type t2.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
      --security-group-ids ${SGID} \
      --iam-instance-profile Name=SecretManager_role_Roboshop \
      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
      echo Server IP Address = ${PRIVATE_IP}
}

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
#AMI_ID=ami-0679e2f4396cdb59e
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')

if [ -z "$1" ]; then
  echo "Input the node name"
  exit 1
else
  COMPONENT=$1
  create_ec2
fi