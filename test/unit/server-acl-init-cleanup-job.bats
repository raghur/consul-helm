#!/usr/bin/env bats

load _helpers

@test "serverACLInitCleanup/Job: disabled by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-job.yaml  \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInitCleanup/Job: enabled with global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-job.yaml  \
      --set 'global.acls.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "serverACLInitCleanup/Job: disabled with server=false and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-job.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'server.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInitCleanup/Job: enabled with client=true and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-job.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'client.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "serverACLInitCleanup/Job: disabled when server.updatePartition > 0" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-job.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'server.updatePartition=1' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInitCleanup/Job: consul-k8s delete-completed-job is called with correct arguments" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-job.yaml  \
      --set 'global.acls.enabled=true' \
      . | tee /dev/stderr |
      yq -c '.spec.template.spec.containers[0].args' | tee /dev/stderr)
  [ "${actual}" = '["delete-completed-job","-k8s-namespace=default","release-name-consul-server-acl-init"]' ]
}
