#!/bin/bash

set -eux

pushd websh_server
WEBSH_DOCKER_IMAGE=jiro4989/websh ./bin/websh_server &
pid=$!
sleep 2
# 出力内容を確認する用
curl -s --connect-timeout 5 -X POST -d '{"code":"echo hello"}' 'http://0.0.0.0:5000/shellgei'
# 標準出力のテスト
cnt=$(curl -s --connect-timeout 5 -X POST -d '{"code":"echo hello"}' 'http://0.0.0.0:5000/shellgei' | grep hello | wc -l)
[ "$cnt" -eq 1 ]
# 標準エラー出力のテスト
cnt=$(curl -s --connect-timeout 5 -X POST -d '{"code":"echo hello >&2"}' 'http://0.0.0.0:5000/shellgei' | grep hello | wc -l)
[ "$cnt" -eq 1 ]
kill $pid
popd