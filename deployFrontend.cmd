robocopy src docs /e
robocopy build\contracts docs
git add .
git commit -m "Adding front end files to git hub pages"
git push
