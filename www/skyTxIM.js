var exec = require('cordova/exec');

exports.events={
    RECEIVE_MSG:'receiveMsg',
    KICKOUT_LINE:'kickoutLine',
    SIG_EXPIRED:'sigExpired',
};

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'skyTxIM', 'coolMethod', [arg0]);
};

exports.sendMessageJsToIm = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'sendMessageJsToIm', message);
};

// exports.addListenIMInfo = function ( success, error,message) {
//     exec(success, error, 'skyTxIM', 'addListenIMInfo',message);
// };
exports.on = function (eventName, success, error,message) {
    exec(success, error, 'skyTxIM', eventName, message);
};
exports.loginIM = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'loginIM', message);
};

exports.loginOutIM = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'loginOutIM', message);
};

exports.histroyMessage = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'histroyMessage', message);
};

exports.setReadMessage = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'setReadMessage',message);
};
exports.getUnReadMessageNum = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'getUnReadMessageNum',message);
};
exports.getLastMsg = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'getLastMsg',message);
};
exports.getConversationList = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'getConversationList', message);
};
exports.getOnlineUser = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'getOnlineUser', message);
};
exports.setNotificationNum = function ( success, error,message) {
    exec(success, error, 'skyTxIM', 'setNotificationNum', message);
};
