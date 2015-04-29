passport = require 'passport'

module.exports =
  # login page
  login: (req, res) ->
    if req.isAuthenticated && req.isAuthenticated()
      res.redirect 'dashboard'
    else
      res.view()

  # authentication
  process: (req, res) ->
    passport.authenticate('local', (err, user, info)->
      if err || !user
        return res.send {
          message: "login failed: #{err}, #{user}"
        }

      req.logIn(user, (err) ->
        if err
          console.log "error at login #{err}"
          res.send err
        else
          res.redirect '/dashboard'
      )
    )(req, res)

  # logout
  logout: (req, res)->
    req.logout()
    res.redirect '/'
