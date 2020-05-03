#!/bin/bash
# This files synchronizes the remote repository online

hugo
git add --all
git commit -m "updated"
git push -u origin master