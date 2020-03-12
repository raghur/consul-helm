#!/usr/bin/env bats

load _helpers

@test "serverACLInit/ServiceAccount: disabled by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-serviceaccount.yaml  \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInit/ServiceAccount: enabled with global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-serviceaccount.yaml  \
      --set 'global.acls.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "serverACLInit/ServiceAccount: disabled with server=false and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-serviceaccount.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'server.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "serverACLInit/ServiceAccount: enabled with client=false and global.acls.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/server-acl-init-serviceaccount.yaml  \
      --set 'global.acls.enabled=true' \
      --set 'client.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}
