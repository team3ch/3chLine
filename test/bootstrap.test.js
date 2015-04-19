var Sails = require('sails');
var sails;

before(function(done) {
  Sails.lift({

  }, function(err, server) {
    sails = server;

    if(err) return done(err);

    done(err, sails)
  })
})

after(function(done) {
  sails.lower(done);
})
