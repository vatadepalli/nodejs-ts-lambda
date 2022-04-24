import dotenv from "dotenv";
dotenv.config();

export default {
	account: process.env.SNOWFLAKE_ACCOUNT as string,
	username: process.env.SNOWFLAKE_USERNAME as string,
	password: process.env.SNOWFLAKE_PASSWORD as string,
	database: process.env.SNOWFLAKE_DATABASE as string,
	schema: process.env.SNOWFLAKE_SCHEMA as string,
	warehouse: process.env.SNOWFLAKE_WAREHOUSE as string,
	role: process.env.SNOWFLAKE_ROLE as string,
};
