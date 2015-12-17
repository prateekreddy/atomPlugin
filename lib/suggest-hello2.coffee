provider = require './provider'
path = require 'path'

atom.workspace.observeTextEditors (editor) ->
  if path.extname(editor.getPath()) == ".html"
    provider.makeWordList(editor)                   #implement destroying the wordlist on closing the editor


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
