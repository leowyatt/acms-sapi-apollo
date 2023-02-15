const pg = require("pg");
const { GraphQLError } = require("graphql");
const { ApolloServer } = require("@apollo/server");

const { startStandaloneServer } = require("@apollo/server/standalone");

const { makeSchemaAndPlugin } = require("postgraphile-apollo-server");

const postGraphileOptions = {
  // jwtSecret: process.env.JWT_SECRET || String(Math.random()),
  // subscriptions: true,
  appendPlugins: [
    require("@graphile-contrib/pg-simplify-inflector"),
    require("postgraphile-plugin-connection-filter"),
  ],
  // dynamicJson: true,
  // etc
};

const dbSchema = process.env.SCHEMA_NAMES
  ? process.env.SCHEMA_NAMES.split(",")
  : "public";

const pgPool = new pg.Pool({
  connectionString:
    process.env.DATABASE_URL || "postgres://db:db@127.0.0.1:4021/db",
});

async function main() {
  // See https://www.graphile.org/postgraphile/usage-schema/ for schema-only usage guidance
  const { schema, plugin } = await makeSchemaAndPlugin(
    pgPool,
    dbSchema,
    postGraphileOptions
  );

  // See https://www.apollographql.com/docs/apollo-server/api/apollo-server.html#ApolloServer
  const server = new ApolloServer({
    schema,
    plugins: [plugin],
  });

  const { url } = await startStandaloneServer(server, {
    // context: async ({ req }) => ({ token: req.headers.token }),
    listen: { port: 4010 },
  });
  console.log(`🚀  Server ready at ${url}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
