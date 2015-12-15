css = require 'css'
fs = require 'fs'

module.exports =
  selector: '.text.html .string'
  disableForSelector: '.text.html .comment'

  # This will take priority over the default provider, which has a priority of 0.
  # `excludeLowerPriority` will suppress any providers with a lower priority
  # i.e. The default provider will be suppressed
  inclusionPriority: 5
  excludeLowerPriority: true

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    new Promise (resolve) ->
      # console.log "working"
      testero = (obj) ->
        console.log obj.range.end
        if obj.range.end.column is bufferPosition.column
          cssFiles = []
          classList = []
          list = []
          # console.log(editor)
          # console.log(bufferPosition)
          # console.log(scopeDescriptor)
          # console.log(prefix)

          getCssFiles = (object) ->
            line = object.lineText
            link = line.match(/[\w._/]+\.css/)
            cssFiles.push(link)
          # editor =atom.workspace.getActiveTextEditor()
          editor.scan(/stylesheet/g, getCssFiles)
          currentPath = editor.getPath().substring 0,editor.getPath().lastIndexOf("\\")+1
          for file in cssFiles
            cssText = fs.readFileSync currentPath + file.toString(), 'utf8'
            # console.log file.toString()

            cssParseObj = css.parse cssText
            # console.log cssParseObj

            if cssParseObj.type == "stylesheet"
              rules = cssParseObj.stylesheet.rules
              # console.log rules
              for oneRule in rules
                # console.log oneRule
                if oneRule.type == "rule"
                  # console.log oneRule.selectors
                  for oneSelector in oneRule.selectors
                    if oneSelector !=oneRule.selectors[0]
                      console.log "it is wroking here"
                      console.log oneRule
                    # console.log oneSelector
                    # console.log classList.indexOf oneSelector
                    if classList.indexOf oneSelector ==-1
                      classList = classList.concat oneSelector.split(' ')
          class trie
            head : {}
            insertIntoTrie : (word) ->
              temp = @head
              for letter in word
                temp[letter] = {} unless temp[letter]?
                temp = temp[letter]
              temp["word"] = word

          sugg = new trie()
          sugg.insertIntoTrie(classes) for classes in classList

          list = sugg.search prefix
          # console.log list

          resolve list
      # console.log bufferPosition.row
      editor.buffer.backwardsScanInRange(/\bclass\s?=\s?(?:"|')[a-z][\w-:]*/i, [[0,0], [bufferPosition.row,bufferPosition.column]], testero)


  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  dispose: ->

    # cssFiles = []
    # classList = []
    # callback = (object) ->
    #   line = object.lineText
    #   link = line.match(/[\w._/]+\.css/)
    #   cssFiles.push(link)
    # editor =atom.workspace.getActiveTextEditor()
    # editor.scan(/stylesheet/g, callback)
    # currentPath = editor.getPath().substring(0,editor.getPath().lastIndexOf("\\")+1)
    # for file in cssFiles
    #   cssText = fs.readFileSync(currentPath + file.toString(), 'utf8')
    #   console.log file.toString()
    #
    #   cssParseObj = css.parse(cssText)
    #   console.log cssParseObj
    #
    #
    #   if cssParseObj.type == "stylesheet"
    #     rules = cssParseObj.stylesheet.rules
    #     # console.log rules
    #     for oneRule in rules
    #       # console.log oneRule
    #       if oneRule.type == "rule"
    #         # console.log oneRule.selectors
    #         for oneSelector in oneRule.selectors
    #           # console.log oneSelector
    #           if classList.indexOf(oneSelector)==-1
    #             if oneSelector[0] == "."
    #               type = "class"
    #               # oneSelector = oneSelector.substring(1,oneSelector.length)
    #             else if oneSelector[0] == "#"
    #               type = "id"
    #               # oneSelector = oneSelector.substring(1,oneSelector.length)
    #             else
    #               type = "tag"
    #             classList.push({"name": oneSelector, "type": type})
    # console.log classList
