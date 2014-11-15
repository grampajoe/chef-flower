#!/usr/bin/env bats

@test 'python is installed' {
    run /opt/flower/bin/python --version
    [ "$status" -eq 0 ]
}
