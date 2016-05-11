---
layout:     post
title:      git Cheat Sheet
date:       2016-05-11 13:12 +1200
summary:    Git Cheat Sheet
thumbnail:  cogs
tags:       git
---

* TOC
{:toc}

# Setup

* ```git config --global user.name "John Doe"```
* ```git config --global user.email john@example.com```

The ```--global``` option stores records in ```~/.gitconfig```. Local config options
are saved to the ```.git/config``` file in the repository.

Aliases can be set for long command strings

* ```git config --global alias.st status```

# Creating repositories

## Initialise a repository

* ```git init <path>```

This creates a ```.git``` folder in the root of the repository. Unlike SVN, it only
appears in the root, and not every folder.

## Clone an existing repository

* ```git clone <path_to_repo>```

The path can be HTTP, SSH, FTP, git or a file system path.

# Staging

Staging can be used to selectively commit groups of files

* ```git add <file>```. Add a file to the staging area
* ```git reset <file>```. Unstage the file without affecting the working copy
* ```git rm --cached<file>```. Stage a deletion of the file without deleting the working copy
* ```git status```. View the staging area



# Branchings

* [Branching](http://nvie.com/posts/a-successful-git-branching-model/)

