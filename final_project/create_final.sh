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
cmd[2]="create_tolkien.sql"
cmd[3]="types/dwarf_t.sql"
cmd[4]="types/elf_t.sql"
cmd[5]="types/goblin_t.sql"
cmd[6]="types/hobbit_t.sql"
cmd[7]="types/maia_t.sql"
cmd[8]="types/man_t.sql"
cmd[9]="types/orc_t.sql"
cmd[10]="types/elf_subtypes/noldor_t.sql"
cmd[11]="types/elf_subtypes/silvan_t.sql"
cmd[12]="types/elf_subtypes/sindar_t.sql"
cmd[13]="types/elf_subtypes/teleri_t.sql"
cmd[14]="type_validation.sql"
cmd[15]="insert_instances.sql"
cmd[16]="query_instances.sql"

# Call the array elements.
for i in ${cmd[*]}; do
  sqlplus -s ${username}/${password} @${directory}/${i} > /dev/null
done

# Print query log files
cat logs/type_validation.txt
cat logs/query_instances.txt
