#!/usr/bin/bash

# Assign user and password
username="student"
password="student"
directory="/home/student/Documents/aSmithCode/CIT325/final_project"

echo "User name:" ${username}
echo "Password: " ${password}
echo "Directory:" ${directory}

# Define an array.
declare -a cmd

# Assign elements to an array.
cmd[0]="types/base_t.sql"
cmd[1]="create_tolkien.sql"
cmd[2]="types/dwarf_t.sql"
cmd[3]="types/elf_t.sql"
# cmd[4]="goblin_t.sql"
# cmd[5]="hobbit_t.sql"
# cmd[6]="maia_t.sql"
# cmd[7]="man_t.sql"
# cmd[8]="orc_t.sql"
cmd[4]="types/elf_subtypes/noldor_t.sql"
# cmd[10]="silvan_t.sql"
# cmd[11]="sindar_t.sql"
# cmd[12]="teleri_t.sql"
# cmd[13]="type_validation.sql"
cmd[5]="insert_instances.sql"
cmd[6]="query_instances.sql"

# Call the array elements.
for i in ${cmd[*]}; do
  sqlplus -s ${username}/${password} @${directory}/${i} > /dev/null
done

# Print query log files.
# cat type_validation.txt
cat logs/query_instances.txt
