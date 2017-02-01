module.exports =
  activatePackages: ->
    workspaceElement = atom.views.getView atom.workspace
    packages = ['atom-latex']
    activationPromise = Promise.all packages.map (pkg) ->
      atom.packages.activatePackage pkg
    atom.commands.dispatch(workspaceElement, 'atom-latex:kill')
    return activationPromise

  setConfig: (keyPath, value) ->
    @originalConfigs ?= {}
    @originalConfigs[keyPath] ?=
      if atom.config.isDefault keyPath then null else atom.config.get keyPath
    atom.config.set keyPath, value

  restoreConfigs: ->
    if @originalConfigs
      for keyPath, value of @originalConfigs
        atom.config.set keyPath, value

  callAsync: (timeout, async, next) ->
    if typeof timeout is 'function'
      [async, next] = [timeout, async]
      timeout = 5000
    done = false
    nextArgs = null

    runs ->
      async (args...) ->
        done = true
        nextArgs = args


    waitsFor ->
      done
    , null, timeout

    if next?
      runs ->
        next.apply(this, nextArgs)
