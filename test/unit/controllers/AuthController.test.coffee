assert = require 'assert'
req = require 'supertest'

userId = 'pass'
username = 'pass'
password = 'pass'

loginCookies = null

before (done)->
  User.create(
    userId: userId
    username: username
    password: password
  ).then(() ->
    req(sails.hooks.http.app)
      .post('/auth/process')
      .send(
        userId: userId
        password: password
      )
      .end (err, res) ->
        assert.fail(err) if err
        loginCookies = res.headers['set-cookie'].pop().split(';')[0]
        done()
  ).catch (err)->
    assert.fail err
    done()

describe 'AuthController', ()->
  describe '#login', ()->
    it 'return 200', (done) ->
      req(sails.hooks.http.app)
        .get('/auth/login')
        .send()
        .expect(200, done)

    it 'should redirect to dashboard when authenticated', (done)->
      r = req(sails.hooks.http.app).get('/auth/login')
      r.cookies = loginCookies
      r.send().expect(302).expect('Location', '/dashboard', done)

  describe '#logout', ()->
    it 'should redirect to / when not authenticated', (done)->
      req(sails.hooks.http.app)
        .get('/auth/logout')
        .send()
        .expect(302)
        .expect('Location', '/', done)

    it 'should redirect to / when authenticated', (done)->
      r = req(sails.hooks.http.app).get('/auth/logout')
      r.cookies = loginCookies
      loginCookies = null
      r.send().expect(302).expect('Location', '/', done)

  describe '#process', () ->
    it 'should redirect to dashboard with incoreect password', (done) ->
      unauthorizedStatus = 401
      req(sails.hooks.http.app)
        .post('/auth/process')
        .send(
          userId: userId
          password: password + 1
        )
        .expect(unauthorizedStatus, done)

    it 'should redirect to dashboard with correct password', (done)->
      req(sails.hooks.http.app)
        .post('/auth/process')
        .send(
          userId: userId
          password: password
        )
        .expect(302)
        .expect('Location', '/dashboard', done)
