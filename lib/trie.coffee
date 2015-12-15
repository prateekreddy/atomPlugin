array = ["hi", "how", "hello", "here"]

class trie
  head : {}
  insertWord : (word) ->
    temp = @head
    for letter in word
      temp[letter] = {} unless temp[letter]?
      temp = temp[letter]
    temp["word"] = word

  insertWords : (words) ->
    sugg.insertWord(word) for word in words

  search : (word, nodeSearch) ->
    temp = @head
    count = 0
    for letter in word
      count++;
      if temp[letter]?
        # console.log letter
        temp = temp[letter]
        # console.log  temp
        if nodeSearch
          flag = (count == word.length)
        else
          flag = (temp.word == word)
        return temp if flag
      else
        return
    return

  DFS : (node) ->
    words=[]
    for child in Object.keys(node)
      # console.log child
      if node[child].word?
        # console.log node[child].word

        console.log "first"
        console.log child
        words.push node[child].word
        delete node[child].word
      else if child == "word"
        console.log "second"
        console.log child
        words.push node[child]
      if !node[child].word? && child!= "word"
        # console.log node[child]
        console.log "third"
        console.log child
        words = words.concat @DFS node[child]
    words

  wordsWithPrefix : (prefix) ->
    prefixNode = @search(prefix, true)
    @DFS prefixNode

sugg = new trie()
sugg.insertWord "hello"
sugg.insertWord "here"
sugg.insertWord "hi"
sugg.insertWord "he"
# console.log (JSON.stringify sugg.head, null, 4)

console.log (JSON.stringify (sugg.wordsWithPrefix "he"), null, 4)
