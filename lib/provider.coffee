module.exports =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'

  # This will take priority over the default provider, which has a priority of 0.
  # `excludeLowerPriority` will suppress any providers with a lower priority
  # i.e. The default provider will be suppressed
  inclusionPriority: 5
  excludeLowerPriority: true

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    new Promise (resolve) ->
      console.log(editor)
      console.log(bufferPosition)
      console.log(scopeDescriptor)
      console.log(prefix)
      callback: object ->
        line = object.lineText
        console.log line
      atom.workspace.getActiveTextEditor().scan(/stylesheet/g, callback(object))

      resolve([text: 'hello'])

  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  dispose: ->
