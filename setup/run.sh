## INPUTS
RUN_MODE=$1
NAME_LIST_FILE=namespaces.txt #namespaces.txt.example

## FUNCTIONS
function proceed_confirmation() {
    read -p "> proceed? (y/n): " confirm && [[ ${confirm} == [yY] ]] || exit 2
}

function generate_namespace_list() {
    cat ${NAME_LIST_FILE} \
    | tr '[:upper:]' '[:lower:]' \
    | cut -c1-5 \
    | sed -e 's/$/-wp-activity/'
}

function print_namespace_list() {
    if [[ ! -f "$NAME_LIST_FILE" ]]; then
        echo "[error] $NAME_LIST_FILE is missing.."
        exit 1
    fi
    generate_namespace_list | xargs -I{} sh -c 'echo - {}'
    echo
}

## RUN
if [[ "$RUN_MODE" == "print" ]]; then
    echo "# Print list of namespaces"
    print_namespace_list
elif [[ "$RUN_MODE" == "apply" ]]; then
    echo "# Create namespaces and mysql deployments"
    print_namespace_list
    proceed_confirmation
    generate_namespace_list | xargs -I{} sh -c 'kubectl create namespace {}; kubectl apply -n{} -f mysql.yaml'
elif [[ "$RUN_MODE" == "delete" ]]; then
    echo "# Delete namespaces"
    print_namespace_list
    proceed_confirmation
    generate_namespace_list | xargs -I{} sh -c 'kubectl delete --force namespace {}'
else
    echo "---------------------------"
    echo "description:"
    echo "  helper script to setup/teardown namespace and mysql deployments"
    echo "command:"
    echo "  ./run.sh <print|apply|delete>"
    echo "---------------------------"
fi
