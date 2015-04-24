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
    it('is required', function(done) {
      User.create({
        username: 'missing userId'
      }).then(function() {
        assert.fail()
      }, function(e) {
        assert(/required/.test(e.errors.userId))
      }).finally(done)
    })
    it('should be 20 chars or less', function(done) {
      User.create({
        userId: '12345678901234567890',
        username: '20 chars'
      }).then(function() {
        assert(true)
      }, function() {
        assert.fail()
      }).finally(done)
    })
    it('should not be 21 chars or more', function(done) {
      User.create({
        userId: '123456789012345678901',
        username: '21 chars'
      }).then(function() {
        assert.fail()
      }, function(e){
        assert(/maxLength/.test(e.errors.userId))
      }).finally(done)
    })
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
        User.create([
          {
            userId: 'abcdefghij',
            username: 'only alphabet'
          }, {
            userId: 'klmnopqrstuvwxyz',
            username: 'only alphabet2'
          }
        ]).catch(function() {
          assert.fail()
        }).finally(done)
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
  describe('#username', function() {
    it('is required', function(done) {
      User.create({
        userId: 'username_missing'
      }).then(function() {
        assert.fail()
      }, function(e) {
        assert(/required/.test(e.errors.username))
      }).finally(done)
    })
    it('should be string', function() {
      assert.strictEqual(typeof user1.username, 'string')
    })
    it('should be 128 chars or less', function(done) {
      var name128 = '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678'
      assert.equal(name128.length, 128)
      User.create({
        userId: '128',
        username: name128
      }).then(function() {
        assert(true)
      }, function() {
        assert.fail()
      }).finally(done)
    })
    it('should not be 129 chars or more', function(done) {
      var name129 = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
      assert.equal(name129.length, 129)
      User.create({
        userId: '129',
        username: name129
      }).then(function() {
        assert.fail()
      }, function(e) {
        assert(/maxLength/.test(e.errors.username))
      }).finally(done)
    })
  })
})
