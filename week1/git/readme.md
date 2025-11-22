### Setup & Configuration
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --list              # view configs
```

### Start a Repository
```bash
git init                   # create new local repo
git clone <url>            # copy remote repo to local
```

### Track Changes
```bash
git status                # check current state
git add <file>            # stage a file
git add .                 # stage all changed files
git commit -m "message"   # commit staged changes
```

# Work with Remote
```bash
git remote -v                 # show remote URLs
git push origin <branch>      # upload local commits
git pull                      # get changes and merge
```
