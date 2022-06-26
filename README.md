# nginx_server
Terraform that configures a public HTTP Nginx server ECS Fargate (AWS). This uses an average CPU autoscaling policy and will scale out up to a maximum number of tasks. The distribution of Fargate to Fargate Spot is 1:1

Built and tested on the following environment:
```
Ubuntu 20.04.4 LTS
Terraform v1.2.3
Terragrunt v0.38.1
```


## Configuring
1. Navigate to the required region folder `eu-west-1` and/or `ap-southeast-2`
2. Set region-specific variables for any of the following. Note that `region` and `bucket_region` shouldn't be changed.
```
vpc_cidr      (VPC CIDR range)
subnet_ranges (number of subnets)

min_capacity                  (min Fargate ECS capacity)
max_capacity                  (max Fargate ECS capacity)
scale_in_cooldown_seconds     (time before scale-in events)
scale_out_cooldown_seconds    (time before scale-out events)
cpu_target_percent            (average CPU percent target for autoscaling)
fargate_to_spot_ratio         (ratio of Fargate to Fargate Spot instances)
```

## Building
1. Navigate to the required region folder 
2. Run `terragrunt init && terragrunt apply`
3. Review changes and type `yes`

## Destroying
1. In the relevant region folder run `terragrunt destroy`
2. Review changes and type `yes`