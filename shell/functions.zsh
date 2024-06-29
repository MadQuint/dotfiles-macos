function exists() {
  # `command -v` is similar to `which`
  # https://stackoverflow.com/a/677212/1341838
  command -v $1 >/dev/null 2>&1

  # More explicitly written:
  # command -v $1 1>/dev/null 2>/dev/null
}

function mkcd() {
  mkdir -p "$@" && cd "$_"
}

# update zsh plugins
function uz() {
  antidote update
}

# cd to root dir of git project
function droot() {
  cd $(git rev-parse --show-toplevel)
}

# prompt the AI in the terminal
# e.g. ask How do I install Homebrew
# Do not add a question mark and avoid quotes if possible
function ask() {
	jq -n \
		--arg content "$*" \
		'{
      "model": "llama-3-sonar-large-32k-online",
      "messages": [
        {
          "role": "user",
          "content": $content
        }
      ],
      "stream": true
    }' | curl --silent \
		--request POST \
		--url https://api.perplexity.ai/chat/completions \
		--header 'accept: application/json' \
		--header "authorization: Bearer ${PERPLEXITY_API_TOKEN}" \
		--header 'content-type: application/json' \
		--data @- | jq --unbuffered --raw-input -j 'gsub("^data: "; "") | gsub("\r$"; "") | select(. != null and . != "") | fromjson | .choices[0].delta.content'
}

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall() {
  local _commit=$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

  # Check if a commit without "--wip--" was found and it's not the same as HEAD
  if [[ "$_commit" != "$(git rev-parse HEAD)" ]]; then
    git reset $_commit || return 1
  fi
}
