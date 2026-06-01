#!/usr/bin/env bats

commitToTestRepo() {
  run bash -c "mkdir $1; cd $1; git init; echo testLine > testFile.txt; git add testFile.txt; git commit -m $2"
}

deleteTestRepo() {
  run bash -c "rm -rf $1"
}

@test "prints help message when no matcher set" {
  run ./commands/check.sh
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Error. Matcher not set" ]]
  [[ "$output" =~ "usage: commiterator check (regular_expression)" ]]
  [[ "$output" =~ "Checks if the commit message contains the supplied regular expression. Looks at current value in .git/COMMIT_EDITMSG" ]]
}

@test "validates matcher with value in .git/COMMIT_EDITMSG" { 
  commitToTestRepo testRepo TEST-12345
  run ./commands/check.sh TEST-[0-9]{4}
  [ "$status" -eq 0 ]
}