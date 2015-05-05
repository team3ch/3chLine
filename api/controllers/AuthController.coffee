passport = require 'passport'

module.exports =
  # login page
  login: (req, res) ->
    if req.isAuthenticated && req.isAuthenticated()
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
          res.status(302).redirect '/dashboard'
      )
    )(req, res)

  # logout
  logout: (req, res)->
    req.logout()
    res.status(302).redirect '/'

  twitter: passport.authenticate('twitter')

  twittercallback: passport.authenticate 'twitter',
    failureRedirect: '/login?state=undefined'
    successRedirect: '/dashboard'
