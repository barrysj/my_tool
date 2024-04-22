#/bin/bash
# @author: barrysj
# @create date: 2024-01-23

# 在多个k8s集群的多个pod批量执行命令/拷贝文件
# 集群由多个k8s的集群配置文件指定，用分号隔开
# pod目前只支持固定前缀名字+递增数字

POD_NAME_BASE=pod-name
K8S_NAME_SPACE=ns

function usage(){
    echo "Usage: $0 [action] [k8s_config] [pod_cnt] [args]"
    echo "  Action:"
    echo "    exec     Execute shell command in every pod."
    echo "    cp       Copy local file path to pod's destination file path."
    echo "  Examples:"
    echo "    $0 exec \"cls-abcd.kubeconf;cls-efgh.kubeconf\" 2 \"cd /home;touch foo.txt;\""
    echo "    $0 cp \"cls-abcd.kubeconf;cls-efgh.kubeconf\" 2 /home/local_test.txt /home/remote_test.txt"
    echo ""
    echo -e "\033[31;49;1m  This script is now highly customized, if you need specify other prefix of the pod name or name space then please edit the shell script by yourself\033[39;49;0m"
}

function action_exec(){
    CONFIG_FILES=$1
    POD_CNT=$2
    COMMANDS=$3

    IFS=';' read -ra CONFIG_ARRAY <<< "$CONFIG_FILES"
    # 读取每个集群配置文件
    for CONFIG_FILE in ${CONFIG_ARRAY[@]}
    do
        for ((idx=0; idx<$POD_CNT; idx++)); do
            POD_NAME="$POD_NAME_BASE-$idx-0"
            echo -e "\033[32;49;1m${CONFIG_FILE} -> \033[31;49;1m${POD_NAME}\033[39;49;0m"
            # 在pod上执行命令
            kubectl --kubeconfig $CONFIG_FILE -n $K8S_NAME_SPACE exec $POD_NAME -- /bin/bash -c "$COMMANDS"
        done
    done
}

function action_cp(){
    CONFIG_FILES=$1
    POD_CNT=$2
    LOCAL_FILE=$3
    POD_FILE=$4

    IFS=';' read -ra CONFIG_ARRAY <<< "$CONFIG_FILES"
    # 读取每个集群配置文件
    for CONFIG_FILE in ${CONFIG_ARRAY[@]}
    do
        for ((idx=0; idx<$POD_CNT; idx++)); do
            POD_NAME="$POD_NAME_BASE-$idx-0"
            echo -e "\033[32;49;1m${CONFIG_FILE} -> \033[31;49;1m${POD_NAME}\033[39;49;0m"
            kubectl --kubeconfig $CONFIG_FILE -n $K8S_NAME_SPACE cp $LOCAL_FILE ${POD_NAME}:${POD_FILE}
        done
    done
}

ACTION=$1
if [ ${ACTION}x == "exec"x ]; then
    echo -e "\033[31;49;1maction->exec\033[39;49;0m"
    shift 1
    action_exec "$1" "$2" "$3"
elif [ ${ACTION}x == "cp"x ]; then
    echo -e "\033[31;49;1maction->cp\033[39;49;0m"
    shift 1
    action_cp $@
else
    usage $@
fi