#!/usr/bin/env bats

@test 'python is installed' {
    run python --version
    [ "$status" -eq 0 ]
}
