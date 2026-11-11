#!/bin/bash

source ./common.sh

check_root

dnf module enable mysql:8.4 -y &>> $logs_file
dnf install mysql-server -y &>> $logs_file
validate $? "Installing mysql"

systemctl enable mysqld &>> $logs_file
systemctl start mysqld 
validate $? "Start and enable mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $logs_file
validate $? "Setup mysql root password"

total_time