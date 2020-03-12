#!/usr/bin/env bats

load _helpers

@test "serverACLInitCleanup/ClusterRoleBinding: disabled by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrolebinding.yaml  \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInitCleanup/ClusterRoleBinding: enabled with global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrolebinding.yaml  \
      --set 'global.acls.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "serverACLInitCleanup/ClusterRoleBinding: disabled with server=false and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrolebinding.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'server.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInitCleanup/ClusterRoleBinding: enabled with client=false and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrolebinding.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'client.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}
