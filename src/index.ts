import {
	APIGatewayEventRequestContext,
	APIGatewayProxyEvent,
	APIGatewayProxyResult,
} from "aws-lambda";
import dotenv from "dotenv";
import snowflake from "snowflake-sdk";
import snowflakeConfig from "./config/snowflake";

dotenv.config();

export const handler = async (
	event: APIGatewayProxyEvent,
	context: APIGatewayEventRequestContext
): Promise<APIGatewayProxyResult> => {
	const queries = event.queryStringParameters;
	console.log("Event: ", event);

	const connection = snowflake.createConnection(snowflakeConfig);

	const connectionId = await new Promise<string>((resolve, reject) => {
		connection.connect((err, conn) => {
			if (err) {
				console.error("Unable to connect: " + err.message);
				reject(err);
			} else {
				console.log("Successfully connected to Snowflake.");
				const connectionId = conn.getId();
				resolve(connectionId);
			}
		});
	});

	console.log(connectionId);

	return {
		statusCode: 200,
		body: JSON.stringify({
			message: "Hello World! & Hello Everyone In It!",
			queries,
			snowflake_connection_id: connectionId,
		}),
		headers: { "content-type": "application/json" },
	};
};
