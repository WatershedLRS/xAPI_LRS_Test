"use strict";
var contentTypeCheck,
    versionCheck,
    responses
;

contentTypeCheck = function (res, type) {
    if (type !== "json") {
        return false;
    }
    return res.headers["content-type"].indexOf("application/json") === 0;
};

versionCheck = function (res) {
    return res.headers["x-experience-api-version"].indexOf("1.0") === 0;
};

responses = {
    about: function (res) {
        //TODO:schema check
        return contentTypeCheck(res, "json");
    },
    saveStatement: function (res) {
        return contentTypeCheck(res, "json");
    }
};

module.exports = function (res, type) {
    if (res.statusCode === 200) {
        return (responses[type](res)) && versionCheck(res, type);
    }
    else {
        return versionCheck(res, type);
    }
};
