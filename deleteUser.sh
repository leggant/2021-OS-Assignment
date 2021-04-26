#!/bin/bash

deleteUser() {
    userdel -r -- "${1}" 2>> $log
}


deleteUser 