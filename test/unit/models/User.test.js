var assert = require('assert');

describe('User', function() {
  var user1;
  before(function(done) {
    User.create({
      userId: 'zoi',
      username: 'aoba'
    }).exec(function() {
      User.find().limit(1).then(function(data) {
        user1 = data[0]
        done();
      }).catch(done)
    });
  })

  describe('#id', function() {
    it('should be numeric', function() {
      assert(typeof user1.id === 'number')
    });
    it('should be intager', function() {
      assert.strictEqual(user1.id, parseInt(user1.id, 10))
    })
  })
  describe('#userId', function() {
    it('should be string', function() {
      assert(typeof user1.username === 'string')
    })
    describe('should be alphanumericdashed', function() {
      it('should accept number-only userId', function(done) {
        User.create({
          userId: '0123456798',
          username: 'only number'
        }).exec(done)
      });
      it('should accept alphabet-only userId', function(done) {
        User.create({
          userId: 'abcdefghijklmnopqrstuvwxyz',
          username: 'only alphabet'
        }).exec(done)
      });
      it('should accept dash-only userId', function(done) {
        User.create({
          userId: '-_',
          username:"hyphen and underscore"
        }).exec(done)
      });
      it('should not accept comma', function(done) {
        User.create({
          userId: ',',
          username: 'comma'
        }).then(function() {
          assert.fail();
        }, function() {
          assert(true)
        }).finally(function() {
          done();
        });
      });
    })
    it('should be unique', function(done) {
      User.create({
        userId: 'zoi',
        username: 'aoba-2nd'
      }).then(function() {
        assert.fail();
      }, function(e) {
        assert(/already exists/.test(e.errors.userId))
      }).finally(done)
    })
  })
})
