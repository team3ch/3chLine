/**
 * TweetController
 *
 * @description :: Server-side logic for managing tweets
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	withUser : function(req, res) {
		var users = {};
		var promises = [];
		var ret;
		Tweet.find().exec(function(err, tweets) {
			ret = tweets;
			tweets.forEach(function(t) {
				var id = t.user;
				if(!users[id]){
					users[id] = true
					promises.push(User.findOne(id).then(function(user) {
						users[id] = user
					}));
				}
			})
			Promise.all(promises).then(function() {
				ret.map(function(t) {
					t.user = users[t.user]
					return t;
				});
				res.json(ret)
			});
		});
	},
	withUser2: function(req, res) {
		Tweet.find().populate('user').exec(function(err, data) {
			res.json(data)
		})
	}
};
