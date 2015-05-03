passport = require 'passport'

module.exports =
  # login page
  login: (req, res) ->
    if req.isAuthenticated && req.isAuthenticated()
      console.log 'already authenticated!'
      res.redirect '/dashboard'
    else
      res.view()

  # authentication
  process: (req, res) ->
    passport.authenticate('local', (err, user, info)->
      if err || !user
        return res.status(401).view 'auth/login',
          error: true

      req.logIn(user, (err) ->
        if err
          res.send err
        else
          console.log 'authenticated'
          res.status(302).redirect '/dashboard'
      )
    )(req, res)

  # logout
  logout: (req, res)->
    req.logout()
    res.status(302).redirect '/'
