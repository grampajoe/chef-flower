#!/usr/bin/env bats

@test 'flower is installed' {
    run /opt/flower/bin/celery flower --version
    [ "$status" -eq 0 ]
}
