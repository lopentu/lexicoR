git branch -D lite && git checkout -b lite && rm -r data-raw/ && rm -r inst/ && rm -r docs/ && git add . && git commit -m 'push to branch "lite"' && git push -f origin lite && git checkout master
