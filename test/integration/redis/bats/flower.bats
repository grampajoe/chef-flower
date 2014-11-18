#!/usr/bin/env bats

@test 'the broker should be set' {
    wget -O - localhost:9001 | grep 'redis://localhost:6379/0'
}
