package kubernetes.capacity

import future.keywords.in
import future.keywords.contains

import data.compute.kubernetes

allow_sizing {
  requested_instances := input.num_instances
  requested_instances >= kubernetes.approved_sizing[input.instance_size].min_instances
  requested_instances <= kubernetes.approved_sizing[input.instance_size].max_instances
}

allow_capacity {
  requested_instances := input.num_instances
  (kubernetes.current_clusters + 1) <= kubernetes.max_clusters
}

allow_project {
  input.project in kubernetes.approved_projects
}

allow {
  allow_sizing
  allow_capacity
  allow_project
}

reason contains msg {
  msg := sprintf("Project '%v' is not allowed to deploy Kubernetes clusters", [input.project])
  not allow_project
}

reason contains msg {
  msg := "Insufficient capacity available for additional Kubernetes clusters"
  input
  not allow_capacity
}

reason contains msg {
  min_instances := kubernetes.approved_sizing[input.instance_size].min_instances
  max_instances := kubernetes.approved_sizing[input.instance_size].max_instances

  msg := sprintf("Must use between %v and %v instances for cluster with node size %v", [min_instances, max_instances, input.instance_size])
  not allow_sizing
}
