#!/bin/bash
# This files synchronizes the remote repository online

hugo
git commit -m "updated"
git add --all
git push -u origin master