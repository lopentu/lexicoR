git branch -D lite && git checkout -b lite && rm -r data-raw/ inst/ docs/ pkgdown/ && git add . && git commit -m 'push to branch "lite"' && git push -f origin lite && git checkout master
