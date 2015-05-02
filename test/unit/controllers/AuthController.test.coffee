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
        .expect('location', /dashboard/, done)

  describe '#logout', ()->
    it 'should redirect to /', (done)->
      req(sails.hooks.http.app)
        .get('/auth/logout')
        .send()
        .expect(302)
        .expect('location', '/', done)
