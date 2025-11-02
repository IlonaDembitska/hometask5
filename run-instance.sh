aws ec2 run-instances \
    --image-id ami-01fd6fa49060e89a6\
    --count 1 \
    --instance-type t3.micro \
    --key-name ilonaIXT\
    --security-group-ids sg-0e3073e2c9b3a860c\
    --subnet-id subnet-02a40b5c9bc9c5dbf \
    --user-data file://userdata.sh \
    --iam-instance-profile Name="ec2-profile" \
    --output text