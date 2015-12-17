# array = ["hi", "how", "hello", "here", "he", "hello node"]

module.exports =
class wordBank

  head : {}
  insertWord : (word) ->
    temp = @head
    for letter in word
      temp[letter] = {} unless temp[letter]?
      temp = temp[letter]
    temp["word"] = word

  insertWords : (words) ->
    @insertWord(word) for word in words

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
        words.push node[child].word
        delete node[child].word
      else
        words.push node[child] if child is "word"
      words = words.concat @DFS node[child] unless node[child].word? or child is "word"
    words

  wordsWithPrefix : (prefix) ->
    prefix = prefix.trim()
    # console.log prefix
    prefixNode = @search(prefix, true)
    # console.log prefixNode
    @DFS prefixNode if prefixNode?

# sugg = new trie()
# sugg.insertWords array
# # sugg.insertWord "here"
# # sugg.insertWord "hi"
# # sugg.insertWord "he"
# # console.log (JSON.stringify sugg.head, null, 4)
#
# console.log (JSON.stringify (sugg.wordsWithPrefix "hello"), null, 4)
