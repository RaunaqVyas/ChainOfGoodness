const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

const region = process.env.REGION; 
const userPoolId = process.env.USER_POOL_ID; 

const COGNITO_URL = `https://cognito-idp.${region}.amazonaws.com/${userPoolId}`;

const client = jwksClient({
    jwksUri: `${COGNITO_URL}/.well-known/jwks.json`
});

function getKey(header, callback){
    console.log(header)
    client.getSigningKey(header.kid, (err, key) => {
        var signingKey = key.publicKey || key.rsaPublicKey;
        callback(null, signingKey);
    });
}

module.exports = (req, res, next) => {
    const token = req.header("Authorization")
    ? req.header("Authorization").split(" ")[1]
    : null;

    if (!token) {
        return res.status(401).json({ error: "Access denied. No token provided." });
    }

    jwt.verify(token, getKey, { algorithms: ['RS256'] }, (err, decoded) => {
        if (err) {
            return res.status(401).json({ error: "Auth failed" });
        } else {
            // the 'sub' field of the token should contain the Cognito User ID
            req.user = { id: decoded.sub };
            next();
        }
    });
};
