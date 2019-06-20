#!/bin/bash
#########################################################
## This script can be used for creating subtasks in Jira
## Script takes following inputs
## It (assumes/expects)! email address as username
##      - Username
##      - API token
##      - Parent Ticket ID
## Author :- sanoop
#########################################################
# Create subtask function
function createSubtask(){
    USERNAME=${1}
    API_TOKEN=${2}
    PARENT_TICKET=${3}
    ASSIGNEE=${4}
    if [ -z "${ASSIGNEE}" ]; then
        ASSIGNEE=`echo ${USERNAME} | cut -d'@' -f1`
    else
        ASSIGNEE=`echo ${ASSIGNEE} | cut -d'@' -f1`   
    fi
    curl -D- \
    -X POST \
    --data "{
            \"fields\": {
                    \"project\": {
                            \"key\": \"OPS\"
                    },
                    \"parent\": {
                            \"key\": \"${PARENT_TICKET}\"
                    },
                    \"summary\": \"Reminder:- Sub-task of ${PARENT_TICKET}\",
                    \"description\": \"Just a reminder for you!\",
                    \"issuetype\": {
                            \"id\": \"5\"
                    },
                    \"assignee\":{
                            \"name\":\"${ASSIGNEE}\"
                    }
            }
        }" \
    -u ${USERNAME}:${API_TOKEN} \
    -H "Content-Type: application/json" \
    "https://<yourspace>.atlassian.net/rest/api/2/issue/"
    }
# Help function
function help() {
    echo "Please run the script in following way!"
    echo "./$(basename $0) <Username> <API token> <Parent Ticket Id>"
    echo "There is an optional filed ASSIGNEE. If you set this, assignee will be taken from this, otherwise ticket will be assigned to the username"
    exit
}
#################
# MAIN function
#################
if [ "$#" -lt 3 ]; then
    help
fi
USERNAME=${1}
API_TOKEN=${2}
PARENT_TICKET=${3}
ASSIGNEE=${4}
# Create subtask
createSubtask ${USERNAME} ${API_TOKEN} ${PARENT_TICKET} ${ASSIGNEE}