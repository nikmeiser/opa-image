package main

import data.aws.ec2.instances

default allow = false

shutdown_threshold = 4 * 60 * 60 // 4 hours in seconds

is_idle_instance(instance) {
    current_time := time.now_ns() / 1000000000 // convert nanoseconds to seconds
    last_activity := instance.last_activity / 1000000000 // convert nanoseconds to seconds
    idle_duration := current_time - last_activity
    idle_duration >= shutdown_threshold
}

is_sagemaker_instance(instance) {
    instance.tags["aws:cloudformation:stack-name"] == "sagemaker"
}

is_ec2_instance(instance) {
    instance.tags["aws:cloudformation:stack-name"] == "ec2"
}

main {
    instances[_].id = instance_id
    instances[_].type = instance_type
    instances[_].last_activity = last_activity
    not is_sagemaker_instance(instances[_])
    not is_ec2_instance(instances[_])
    is_idle_instance(instances[_])
    allow = true
}