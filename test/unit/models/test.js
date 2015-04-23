var assert = require('assert');

describe.only('User', function() {
  describe('#id', function() {

    before(function(done) {
      User.create({
        userId: 'zoi',
        username: 'aoba'
      }).exec(done);
    })

    it('should be numeric', function(done) {
      User.find().limit(1).then(function(data) {
        var user = data[0]
        assert.strictEqual(user.id, parseInt(user.id, 10))
        done();
      }).catch(done)
    });
  })
})
