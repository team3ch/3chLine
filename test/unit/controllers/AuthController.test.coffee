assert = require 'assert'
req = require 'supertest'

userId = 'pass'
username = 'pass'
password = 'pass'

before (done)->
  User.create(
    userId: userId
    username: username
    password: password
  ).catch(assert.fail).finally(done)

describe 'AuthController', ()->
  describe '#login', ()->
    it 'return 200', (done) ->
      req(sails.hooks.http.app)
        .get('/auth/login')
        .send()
        .expect(200, done)

    it 'should redirect to dashboard when authenticated', (done)->
      console.log 'authenticate start'
      req(sails.hooks.http.app)
        .post('/auth/process')
        .send(
          userId: userId
          password: password
        )
        .end (err, res) ->
          cookies = res.headers['set-cookie'].pop().split(';')[0]
          assert.fail(err) if err
          console.log 'redirect from login?'
          r = req(sails.hooks.http.app).get('/auth/login')
          r.cookies = cookies
          r.send().expect(302).expect('Location', '/dashboard', done)

  describe '#logout', ()->
    before (done)->
      req(sails.hooks.http.app)
        .post('/auth/login')
        .send(
          userId: userId
          password: password
        )
        .end (err, res)->
          assert.fail err if err
          done()

    it 'should redirect to /', (done)->
      req(sails.hooks.http.app)
        .get('/auth/logout')
        .send()
        .expect(302)
        .expect('Location', /\//, done)

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
