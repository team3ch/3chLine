passport = require 'passport'

module.exports =
  # login page
  login: (req, res) ->
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
          return res.send err
        else
          res.send {
            message: 'logged in sucessfully'
          }
      )
    )(req, res)
    # res.ridirect '/dashboard'

  # logout
  logout: (req, res)->
    res.json
      todo: 'logout() is not implemented yet'
