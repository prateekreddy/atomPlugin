provider = require './provider'

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
