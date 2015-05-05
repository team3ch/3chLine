passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
TwitterStrategy = require('passport-twitter').Strategy
bcrypt = require 'bcrypt'
conf = {}
require('rc')('sails', conf)

findById = (id, fn) ->
  User.findOne(id).exec (err, user)->
    if err
      console.log err
      fn(null, null)
    else
      fn(null, user)

findByUserId = (userId, fn) ->
  User.findOne(
    userId: userId
  ).exec (err, user) ->
    if err
      console.log err
      fn(null, null)
    else
      fn(null, user)

passport.serializeUser (user, done)->
  done(null, user.id)

passport.deserializeUser (id, done)->
  findById(id, (err, user)->
    done(err, user)
  )

passport.use(
  new LocalStrategy({
    usernameField: 'userId',
    passwordField: 'password'
  }, (userId, password, done)->
    User.findOne({
      userId: userId
    }).then((user) ->
      bcrypt.compare(password, user.password, (err, res) ->
        if err
          console.log err
        if(!res)
          msg = 'invalid password'
          return done(null, false, {
            message: msg
          })
        msg = 'Logged in sucessfully'
        done(null, {
          userId: user.userId
          id: user.id
        }, {
          messsage: msg
        })
      )
    ).catch((err)->
      console.log err
      done(null, err)
    )
  )
)

# .sailsrc has twitter keys(consumerKey, consumerSecret, callbackURL)
passport.use new TwitterStrategy conf.twitterAuth,
  (token, tokenSecret, profile, done)->
    User.findOne(
      twitterAccount: profile.id
    ).then((user)->
      profile = user
      done(null, profile)
    ).catch((err)->
      console.log err
      done(err)
    )

module.exports =
  express:
    customMiddleware: (app) ->
      app.use passport.initialize()
      app.use passport.session()
