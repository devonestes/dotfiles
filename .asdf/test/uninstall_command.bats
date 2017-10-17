#!/usr/bin/env bats

load test_helpers

. $(dirname $BATS_TEST_DIRNAME)/lib/commands/reshim.sh
. $(dirname $BATS_TEST_DIRNAME)/lib/commands/install.sh
. $(dirname $BATS_TEST_DIRNAME)/lib/commands/uninstall.sh

setup() {
  setup_asdf_dir
  install_dummy_plugin

  PROJECT_DIR=$HOME/project
  mkdir $PROJECT_DIR
}

teardown() {
  clean_asdf_dir
}

@test "uninstall_command should fail when no such version is installed" {
  run uninstall_command dummy 3.14
  [ "$output" == "No such version" ]
  [ "$status" -eq 1 ]
}

@test "uninstall_command should remove the plugin with that version from asdf" {
  run install_command dummy 1.1
  [ "$status" -eq 0 ]
  [ $(cat $ASDF_DIR/installs/dummy/1.1/version) = "1.1" ]
  run uninstall_command dummy 1.1
  [ ! -f  $ASDF_DIR/installs/dummy/1.1/version ]
}

@test "uninstall_command should invoke the plugin bin/uninstall if available" {
  run install_command dummy 1.1
  [ "$status" -eq 0 ]
  mkdir -p $ASDF_DIR/plugins/dummy/bin
  echo "echo custom uninstall" > $ASDF_DIR/plugins/dummy/bin/uninstall
  chmod 755 $ASDF_DIR/plugins/dummy/bin/uninstall
  run uninstall_command dummy 1.1
  [ "$output" == "custom uninstall" ]
  [ "$status" -eq 0 ]
}

@test "uninstall_command should remove the plugin shims if no other version is installed" {
  run install_command dummy 1.1
  [ -f $ASDF_DIR/shims/dummy ]
  run uninstall_command dummy 1.1
  [ ! -f $ASDF_DIR/shims/dummy ]
}

@test "uninstall_command should leave the plugin shims if other version is installed" {
  run install_command dummy 1.0
  [ -f $ASDF_DIR/installs/dummy/1.0/bin/dummy ]

  run install_command dummy 1.1
  [ -f $ASDF_DIR/installs/dummy/1.1/bin/dummy ]

  [ -f $ASDF_DIR/shims/dummy ]
  run uninstall_command dummy 1.0
  [ -f $ASDF_DIR/shims/dummy ]
}

@test "uninstall_command should remove relevant asdf-plugin-version metadata" {
  run install_command dummy 1.0
  [ -f $ASDF_DIR/installs/dummy/1.0/bin/dummy ]

  run install_command dummy 1.1
  [ -f $ASDF_DIR/installs/dummy/1.1/bin/dummy ]

  run uninstall_command dummy 1.0
  run grep "asdf-plugin-version: 1.1" $ASDF_DIR/shims/dummy
  [ "$status" -eq 0 ]
  run grep "asdf-plugin-version: 1.0" $ASDF_DIR/shims/dummy
  [ "$status" -eq 1 ]
}

@test "uninstall_command should not remove other unrelated shims" {
  run install_command dummy 1.0
  [ -f $ASDF_DIR/shims/dummy ]

  touch $ASDF_DIR/shims/gummy
  [ -f $ASDF_DIR/shims/gummy ]

  run uninstall_command dummy 1.0
  [ -f $ASDF_DIR/shims/gummy ]
}
