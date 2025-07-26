# What the heck is this
It's a Windows command line utility I use to back up my Construct 3 projects periodically to GitHub.

I use `.c3p` files instead of project folders and at certain "checkpoints" I save a new version of them with a different filename, so I end up with files like `MyGame-b01.c3p` (build 1), `MyGame-b02.c3p` (build 2), et cetera. I store them in my Dropbox which also acts as an automatic backup, but more asset heavy projects can take up quite a bit of space after a while.

I made this utility so I can convert those `.c3p` files to git commits, push them to GitHub then remove them.

# How it works
The utility looks for .c3p files with the naming convention `{ProjectName}-{suffix}.c3p` and a git repo in a folder named `{ProjectName}`, then iterates through all `.c3p` files ascending by name and converts them to commits in the matching repo folder. The `{suffix}` part of the project file's name will be the commit message itself. The utility doesn't support project file names with spaces in them at the moment.

After a successful run, you can push changes of the repo to a remote and optionally get rid of the .c3p files to save disk space, as git stores versions of your projects more efficiently.

I also added an `example.gitignore` file which I always add to the repo folders so `*.uistate.json` files are excluded from commits.

