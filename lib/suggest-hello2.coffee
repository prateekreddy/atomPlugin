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

atom.workspace.getActiveTextEditor().onDidChange (obj) ->
  editor = atom.workspace.getActiveTextEditor()
  currentPath = editor.getPath().substring 0,editor.getPath().lastIndexOf("\\")+1
  #have to combine both the regex tests
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
