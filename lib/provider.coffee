css = require 'css'
fs = require 'fs'
wordBank = require './trie'
wordList = {}

module.exports =
  selector: '.text.html .string'
  disableForSelector: '.text.html .comment'
  inclusionPriority: 5
  excludeLowerPriority: true
  wordList : wordList

  makeWordList: (editor)->
    filePath = editor.getPath()
    wordList[filePath] = {}
    wordList[filePath].cssFiles = []
    wordList[filePath].listArray = []
    editor.scan(/stylesheet/g, (object) ->
      line = object.lineText
      link = line.match(/[\w._/]+\.css/)
      wordList[filePath].cssFiles.push(link)
      )
    currentPath = filePath.substring 0,filePath.lastIndexOf("\\")+1
    for file in wordList[filePath].cssFiles when wordList[filePath].cssFiles?
      cssText = fs.readFileSync currentPath + file.toString(), 'utf8'
      cssParseObj = css.parse cssText
      for oneRule in cssParseObj.stylesheet.rules when cssParseObj.type is "stylesheet"
        for oneSelector in oneRule.selectors when oneRule.type is "rule"
          wordList[filePath].listArray = wordList[filePath].listArray.concat oneSelector.split(' ') if wordList[filePath].listArray.indexOf(oneSelector) is -1
    wordList[filePath].listArray
    # console.log wordList

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    new Promise (resolve) ->
      testero = (obj) ->
        if obj.range.end.column is bufferPosition.column
          list = []
          sugg = new wordBank()
          sugg.insertWords wordList[editor.getPath()].listArray
          list = sugg.wordsWithPrefix "."+prefix
          suggestions = []
          suggestions.push({"text": eachWord?.substring(1,eachWord?.length), "type": "class"}) for eachWord in list when list?
          resolve suggestions
      editor.buffer.backwardsScanInRange(/\bclass\s?=\s?(?:"|')[a-z][\w-:]*/i, [[0,0], [bufferPosition.row,bufferPosition.column]], testero)


  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  dispose: ->
