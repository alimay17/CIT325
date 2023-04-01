#!/usr/bin/bash

# Assign user and password
username="student"
password="student"
directory="/home/student/Documents/aSmithCode/CIT325/final_project"

echo "User name:" ${username}
echo "Password: " ${password}
echo "Directory:" ${directory}

# create logs directory
# mkdir ${directory}/logs

# Define an array.
declare -a cmd

# Assign elements to an array.
cmd[0]="tools/object_cleanup.sql"
cmd[1]="types/base_t.sql"
cmd[2]="types/dwarf_t.sql"
cmd[3]="types/elf_t.sql"
cmd[4]="types/goblin_t.sql"
cmd[5]="types/hobbit_t.sql"
cmd[6]="types/maia_t.sql"
cmd[7]="types/man_t.sql"
cmd[8]="types/orc_t.sql"
cmd[9]="types/elf_subtypes/noldor_t.sql"
cmd[10]="types/elf_subtypes/silvan_t.sql"
cmd[11]="types/elf_subtypes/sindar_t.sql"
cmd[12]="types/elf_subtypes/teleri_t.sql"
cmd[13]="create_tolkien.sql"
cmd[14]="type_validation.sql"
cmd[15]="insert_instances.sql"
cmd[16]="query_instances.sql"

# Assign elements to a log array.
log[0]="logs/object_cleanup.txt"
log[1]="logs/base_t.txt"
log[2]="logs/create_tolkien.txt"
log[3]="logs/type_validation.txt"
log[4]="logs/insert_instances.txt"
log[5]="logs/query_instances.txt"

# Call the command array elements.
for i in ${cmd[*]}; do
  # Print the file to show progress and identify fail point.
  if ! [[ -f ${i} ]]; then
    echo "File [${i}] is missing."
  else
    sqlplus -s ${username}/${password} @${directory}/${i} > /dev/null
  fi
done

# Display the log array elements to console.
for i in ${log[*]}; do
  if [[ -f ${i} ]]; then
    cat ${i}
  else
    echo "File [${i}]."
  fi
done
