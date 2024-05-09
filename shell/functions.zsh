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
