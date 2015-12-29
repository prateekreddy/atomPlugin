provider = require './provider'
path = require 'path'
fs = require 'fs'

atom.workspace.observeTextEditors (editor) ->
  if path.extname(editor.getPath()) is ".html"
    provider.makeWordList(editor)
    for cssFile in provider.wordList[editor.getPath()].cssFiles
      fs.watch(cssFile, (event) ->
        provider.makeWordList(editor)
        )

atom.workspace.getActiveTextEditor().onDidChange (obj) ->
  editor = atom.workspace.getActiveTextEditor()
  #TODO-v2: have to include for absolute path and urls
  currentPath = editor.getPath().substring 0,editor.getPath().lastIndexOf("\\")+1
  #TODO-v2: have to combine both the regex tests
  text = editor.buffer.scanInRange(/<\s?link\s?rel=\s?('|")\s?stylesheet\s?\1\s?href\s?=\s?('|")([\w-:.\\/_]*)\2/g, [[obj.start,0], [obj.end+1,0]], (obj) ->
    if !(currentPath+obj.match[3] in provider.wordList[editor.getPath()].cssFiles or obj.match[3] in provider.wordList[editor.getPath()].cssFiles)
      provider.makeWordList(editor)
    )
  text = editor.buffer.scanInRange(/<\s?link\s?href\s?=\s?('|")([\w-:.\\/_]*)\2\s?rel=\s?('|")\s?stylesheet\s?\1\s?/g, [[obj.start,0], [obj.end+1,0]], (obj) ->
    if !(currentPath+obj.match[3] in provider.wordList[editor.getPath()].cssFiles or obj.match[3] in provider.wordList[editor.getPath()].cssFiles)
      provider.makeWordList(editor)
    )



module.exports =
  getProvider: ->
    provider.dispose = ->
      console.log "the plugin is disabled"
    provider
