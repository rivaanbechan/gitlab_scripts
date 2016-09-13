#!/bin/sh

# usage:
# edit your user. Go to Account. Use Private Token
# permissions private 0, internal 10, public 20. Default 0
# Renames origin to gitlab

# vars
token=private_token_goes_here
gitlab='x.x.x.x'
user='gitlab user'

# read user input
read -p "Name:" repo
read -p "description[optional]:" desc
echo "\nprivate 0, internal 10, public 20. Default 0"
read -p "permissions[optional]:" permission
echo "\n"

# make api call
req="$(curl -s -s -o /dev/null -w "%{http_code}" -H "Content-Type:application/json" http://$gitlab/api/v3/projects?private_token=$token -d "{ \"name\": \"$repo\", \"description\": \"$desc\", \"visibility_level\": \"$permission\" }")"

# condition on success or failure of build
# build a skeleton of README.md to more fit the look and feel of other projects on Gitlab
if [ $req == 201 ]; then
	git clone http://$gitlab/$user/$repo.git
	cd $repo
	touch README.md
	echo "# $repo" >> README.md
	echo "" >> README.md
	echo "" >> README.md
	echo "## Project Overview" >> README.md
	echo "Insert project overview here" >> README.md
	echo "" >> README.md
	echo "" >> README.md
	echo "## Requirements" >> README.md
	echo "If your project has requirements and/or dependencies, add them here" >> README.md
	echo "" >> README.md
	echo "" >> README.md
	echo "## Installation" >> README.md
	echo "Clone the git repository anywhere:" >> README.md
	echo "" >> README.md
	echo "    git clone http://$gitlab/UserOrGroup/$repo.git && cd $repo" >> README.md
	echo "" >> README.md
	echo "... or if local DNS is working:" >> README.md
	echo "" >> README.md
	echo "    git clone http://$gitlab/UserOrGroup/$repo.git && cd $repo" >> README.md
	echo "" >> README.md
	echo "" >> README.md
	echo "## Usage" >> README.md
	echo "How to use the files and/or binaries from your project" >> README.md
	echo "" >> README.md
	echo "" >> README.md
	echo "## To Do" >> README.md
	echo "* No Project is ever complete, is it?" >> README.md
	git add README.md
	git commit -m "Add default README.md skeleton"
	git remote rename origin gitlab
	git push -u gitlab master
else
	builtin echo "Failed"
fi

exit 0
