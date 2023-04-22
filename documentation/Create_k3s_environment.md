# Create k3s environment

## Apply AWS resources with Terrafrom

It is necessary to deploy the AWS resources in 2 steps, because a few information for step 2 are not available at the beginning.

### Step 1

```
terraform apply -target=aws_vpc.vpc -target=aws_subnet.public-1a -target=aws_subnet.public-1b -target=aws_subnet.public-1c
```

### Step 2

```
terraform apply
```
