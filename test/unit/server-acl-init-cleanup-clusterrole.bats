#!/usr/bin/env bats

load _helpers

@test "serverACLInitCleanup/ClusterRole: disabled by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrole.yaml  \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInitCleanup/ClusterRole: enabled with global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrole.yaml  \
      --set 'global.acls.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "serverACLInitCleanup/ClusterRole: disabled with server=false and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrole.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'server.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInitCleanup/ClusterRole: enabled with client=true and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrole.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'client.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

#--------------------------------------------------------------------
# global.enablePodSecurityPolicies

@test "serverACLInitCleanup/ClusterRole: allows podsecuritypolicies access with global.enablePodSecurityPolicies=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-cleanup-clusterrole.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'global.enablePodSecurityPolicies=true' \
      . | tee /dev/stderr |
      yq -r '.rules | map(select(.resources[0] == "podsecuritypolicies")) | length' | tee /dev/stderr)
  [ "${actual}" = "1" ]
}
