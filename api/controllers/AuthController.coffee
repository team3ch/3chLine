module.exports =
  # login page
  login: (req, res) ->
    console.log "coffee"
    res.view()

  # authentication
  process: (req, res) ->
    console.log req.body
    res.ridirect '/dashboard'

  # logout
  logout: (req, res)->
    res.json
      todo: 'logout() is not implemented yet'
