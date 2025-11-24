### Create an AWS account 

### Create an IAM user:

Name: terraform-user

![user](screenshot/1.png)

Permissions:

* AmazonEC2FullAccess

* AmazonVPCFullAccess

* IAMReadOnlyAccess

* CloudWatchReadOnlyAccess
  
![user](screenshot/2.png)

- Enable “Access Key”.

![user](screenshot/3.png)

Configure AWS CLI:
```bash
aws configure
```
![user](screenshot/4.png)

Test connectivity:
```bash
aws sts get-caller-identity
```

![user](screenshot/5.png)
