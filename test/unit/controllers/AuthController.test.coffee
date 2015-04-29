assert = require 'assert'
req = require 'supertest'

describe.only 'AuthController', ()->
  describe '#logout', ()->
    it 'should be redirect to /', (done)->
      req(sails.hooks.http.app)
        .get('/auth/logout')
        .send()
        .expect(302)
        .expect('location', '/', done)
