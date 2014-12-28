def render(json, prettify = true)
  if prettify
    puts JSON.pretty_generate(json)
  else
    puts json
  end
end
