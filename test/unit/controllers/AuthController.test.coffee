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

describe 'AuthController', (done)->
  describe '#login', () ->
    it 'should be redirect to dashboard with correct password', ()->
      req(sails.hooks.http.app)
        .post('/auth/login')
        .send(
          userId: userId
          password: password
        )
        .expect(302)
        .expect('location', '/dashboard', done)
  
  describe '#logout', ()->
    it 'should be redirect to /', (done)->
      req(sails.hooks.http.app)
        .get('/auth/logout')
        .send()
        .expect(302)
        .expect('location', '/', done)
