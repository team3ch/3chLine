/**
* Tweet.js
*
* @description :: Tweet is a content user created. It has attributes, who, what and when is is said.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
    id: {
      type: 'integer',
      autoIncrement: true
    },

    userId: {
      type: 'string',
      size: 20,
      required: true
    },

    content: {
      type: 'text',
      required: true
    }
  }
};
