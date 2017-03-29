#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

Will restore a gziped sql dump.

OPTIONS:
   -h      Show this message
   -d      Database name
   -o      Owner
   -f      sql file
EOF
}

DB_NAME=
OWNER=
SQL_FILE=

while getopts "hd:o:f:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        d)
            DB_NAME=$OPTARG
            ;;
        o)
            OWNER=$OPTARG
            ;;
        f)
            SQL_FILE=$OPTARG
            ;;
    esac
done

if [[ -z $DB_NAME ]] || [[ -z $OWNER ]] || [[ -z $SQL_FILE ]]
then
     usage
     exit 1
fi
dropdb $DB_NAME
createdb -O $OWNER -E utf8 $DB_NAME -T template0
gunzip -c $SQL_FILE | psql -d $DB_NAME
