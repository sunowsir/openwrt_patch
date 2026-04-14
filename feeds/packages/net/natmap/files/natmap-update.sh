#!/bin/bash

# 1. 确保目录存在
mkdir -p /var/run/natmap

# 2. 引入 json 库
. /usr/share/libubox/jshn.sh

# 3. 构造 JSON
# 注意：$PPID 是 natmap 主进程的 PID
json_init
json_add_string ip "$1"
json_add_int port "$2"
json_add_int inner_port "$4"
json_add_string protocol "$5"

# 4. 导出到文件 (去掉子 shell，直接 dump)
json_dump > "/var/run/natmap/$PPID.json"

# 5. 清理 json 变量防止干扰后续脚本
json_cleanup

# 6. 处理自定义通知脚本
if [ -n "${NOTIFY_SCRIPT}" ]; then
    # 打印一下调试信息（可选）
    # logger -t natmap "Executing notify script: ${NOTIFY_SCRIPT}"
    export -n NOTIFY_SCRIPT
    exec "${NOTIFY_SCRIPT}" "$@"
fi
