provider = require './provider'
css = require 'css'
fs = require 'fs'

module.exports =

  # activate: (state) ->
  #   provider.loadProperties()

  getProvider: ->
    cssFiles = []
    classList = []
    callback = (object) ->
      line = object.lineText
      link = line.match(/[\w._/]+\.css/)
      cssFiles.push(link)
    editor =atom.workspace.getActiveTextEditor()
    editor.scan(/stylesheet/g, callback)
    currentPath = editor.getPath().substring(0,editor.getPath().lastIndexOf("\\")+1)
    for file in cssFiles
      cssText = fs.readFileSync(currentPath + file.toString(), 'utf8')
      cssParseObj = css.parse(cssText)
      if cssParseObj.type == "stylesheet"
        rules = cssParseObj.stylesheet.rules
        for oneRule in rules
          # console.log oneRule
          if oneRule.type == "rule"
            # console.log oneRule.selectors
            for oneSelector in oneRule.selectors
              # console.log oneSelector
              if classList.indexOf(oneSelector)==-1
                if oneSelector[0] == "."
                  type = "class"
                  oneSelector = oneSelector.substring(1,oneSelector.length)
                else if oneSelector[0] == "#"
                  type = "id"
                  oneSelector = oneSelector.substring(1,oneSelector.length)
                else
                  type = "tag" 
                classList.push({"name": oneSelector, "type": type})
    console.log classList

    # provider
