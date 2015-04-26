assert = require 'assert'

describe 'Tweet', () ->
  user1 = null
  tweet1 = null

  before (done)->
    User.create(
      userId: 'rin',
      username: 'tooyama'
    ).exec (err, u) ->
      assert.fail() if err
      user1 = u
      Tweet.create(
        user: user1.id,
        content: 'kou chan!'
      ).exec (err, t) ->
        assert.fail() if err
        tweet1 = t
        done()

  describe '#id', () ->
    it 'should be numeric', () ->
      assert(typeof tweet1.id == 'number')

    it 'should be intager', () ->
      assert.strictEqual(tweet1.id, parseInt(tweet1.id, 10))

  describe '#content', () ->
    c1024 = null

    it 'should be string', () ->
      assert (typeof tweet1.content == 'string')
      
    it 'should be 1024 chars or less', (done) ->
      limit = 1024
      c = 'c'
      c = c + c while c.length < limit
      assert.strictEqual c.length, limit
      c1024 = c
      Tweet.create(
        user: user1.id,
        content: c1024
      ).exec (err, t) ->
        assert.fail if err
        done()

    it 'should not be 1025 chars or more', (done) ->
      c1025 = c1024 + 'c'
      assert.strictEqual c1025.length, 1025
      Tweet.create(
        user: user1.id,
        content: c1025
      ).exec (err, t) ->
        assert.fail unless err
        assert /maxLength/.test(err.errors.content)
        done()

  describe '#user with population', () ->
    it 'should have userId'
    it 'should have username'
