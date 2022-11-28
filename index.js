const http = require("http");
const { postgraphile } = require("postgraphile");
const fs = require("fs");

if (!fs.existsSync("public")) fs.mkdirSync("public");

const baseConfig = {
  subscriptions: true,
  live: true,
  dynamicJson: true,
  setofFunctionsContainNulls: false,
  ignoreRBAC: false,
  classicIds: true,
  graphiql: true,
  enableQueryBatching: true,
  legacyRelations: "omit",
  exportGqlSchemaPath: "public/schema.graphql",
  watchPg: true,
  pgDefaultRole: "nologin",
  jwtSecret: process.env.JWT_SECRET,
  jwtPgTypeIdentifier: `"secretsanta"."jwt_token"`,
  appendPlugins: [
    require("@graphile-contrib/pg-simplify-inflector"),
    require("@graphile/subscriptions-lds").default,
  ],
  ownerConnectionString: process.env.OWNER_DB_URL,
};

const devConfig = {
  ...baseConfig,
  showErrorStack: "json",
  extendedErrors: ["hint", "detail", "errcode"],
  enhanceGraphiql: true,
};

const prodConfig = {
  ...baseConfig,
  retryOnInitFail: true,
  extendedErrors: ["errcode"],
  disableQueryLog: true,
};

http
  .createServer(
    postgraphile(
      process.env.DATABASE_URL,
      "secretsanta",
      process.env.NODE_ENV == "production" ? prodConfig : devConfig
    )
  )
  .listen(process.env.PORT || 8080);
