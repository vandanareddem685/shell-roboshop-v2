#!/bin/bash

source ./common.sh

check_root

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "copying rabbitmq.repo"

dnf install erlang rabbitmq-server -y &>> $logs_file
validate $? "installing rabbitmq"

systemctl enable rabbitmq-server &>> $logs_file
systemctl start rabbitmq-server &>> $logs_file
validate $? "enable and start rabbitmq"

rabbitmqctl list_users | grep -qw "roboshop"
if [ $? -ne 0 ];then
    rabbitmqctl add_user roboshop roboshop123
    validate $? "Create rabbitmq user"
else
    echo -e "$(timestamp)[INFO] Rabbitmq user already exists.. ${Y} SKIPPING ${N}"
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "Setting permissions for user"

total_time