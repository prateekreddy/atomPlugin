provider = require './provider'
path = require 'path'
fs = require 'fs'

atom.workspace.observeTextEditors (editor) ->
    #implement destroying the wordlist on closing the editor
  if path.extname(editor.getPath()) is ".html"
    provider.makeWordList(editor)
    for cssFile in provider.wordList[editor.getPath()].cssFiles
      fs.watch(cssFile, (event) ->
        console.log event
        provider.makeWordList(editor)
        )

# atom.workspace.onDidChangeActivePane ->
#   if path.extname(editor.getPath()) is ".css"
    # for cssFile in file.cssFiles for file in Object.keys(provider.wordList)
atom.workspace.getActiveTextEditor().onDidChange (obj) ->
  editor = atom.workspace.getActiveTextEditor()
  currentPath = editor.getPath().substring 0,editor.getPath().lastIndexOf("\\")+1
  text = editor.buffer.scanInRange(/<\s?link\s?rel=\s?('|")\s?stylesheet\s?\1\s?href\s?=\s?('|")([\w-:.\\/_]*)\2/g, [[obj.start,0], [obj.end+1,0]], (obj) ->
    # console.log currentPath+obj.match[3] in provider.wordList[editor.getPath()].cssFiles or obj.match[3] in provider.wordList[editor.getPath()].cssFiles
    if !(currentPath+obj.match[3] in provider.wordList[editor.getPath()].cssFiles or obj.match[3] in provider.wordList[editor.getPath()].cssFiles)
      provider.makeWordList(editor)
    )
  text = editor.buffer.scanInRange(/<\s?link\s?href\s?=\s?('|")([\w-:.\\/_]*)\2\s?rel=\s?('|")\s?stylesheet\s?\1\s?/g, [[obj.start,0], [obj.end+1,0]], (obj) ->
    # console.log currentPath+obj.match[3] in provider.wordList[editor.getPath()].cssFiles or obj.match[3] in provider.wordList[editor.getPath()].cssFiles
    if !(currentPath+obj.match[3] in provider.wordList[editor.getPath()].cssFiles or obj.match[3] in provider.wordList[editor.getPath()].cssFiles)
      provider.makeWordList(editor)
    )




module.exports =
  getProvider: ->
    console.log( 'Suggest getting activated')
    provider


# grammar = atom.grammars.grammarsByScopeName['text.html.basic']
# patterns = grammar.rawPatterns;
#
# patterns[patterns.length] =
#   begin : 'class\\=[\\\'|\\"]'
#   end: '[\\\'|\\"]'
#   name : 'class'
#   patterns : '\\w+'
#
# console.log patterns
# module.exports =

  # activate: (state) ->
  #   provider.loadProperties()
