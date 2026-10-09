leetcodeSession(){
  questionNumber=$(leetcode list | fzf | grep -oE "[1-9]+" | head -1)
  pickedQuestion=$(leetcode pick "$questionNumber")
  echo "$pickedQuestion" | bat --file-name yaml --paging=always
}
