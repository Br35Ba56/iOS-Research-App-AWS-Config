package nfpbreastfeedingcognitouserdisable.cognito;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.BufferedReader;
import java.io.Writer;

import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.lambda.runtime.Context; 
import com.amazonaws.services.lambda.runtime.LambdaLogger;


import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.*;



public class ProxyWithStream implements RequestStreamHandler {
    JSONParser parser = new JSONParser();


    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) throws IOException {

        LambdaLogger logger = context.getLogger();
        logger.log("Loading Java Lambda handler of ProxyWithStream");


        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        JSONObject responseJson = new JSONObject();
   
        int responseCode = 200;

        try {
            JSONObject event = (JSONObject)parser.parse(reader);
            System.out.println(event);
           /*if (event.get("queryStringParameters") != null) {
                JSONObject qps = (JSONObject)event.get("queryStringParameters");
                System.out.println(qps);
            }

            if (event.get("pathParameters") != null) {
                JSONObject pps = (JSONObject)event.get("pathParameters");
                System.out.println(pps);
            }

            if (event.get("headers") != null) {
                JSONObject hps = (JSONObject)event.get("headers");
                System.out.println(hps);
            }
            */
            System.out.println("event = " + event);
            if (event.get("body") != null) {
                JSONObject body = (JSONObject)parser.parse((String)event.get("body"));
                System.out.println("JSON body"+body);
            }
            
            
            JSONObject responseBody = new JSONObject();
            responseBody.put("input", event.toJSONString());

            JSONObject headerJson = new JSONObject();
            responseJson.put("isBase64Encoded", false);
            headerJson.put("x-custom-header", "my custom header value");
            responseJson.put("statusCode", responseCode);
            responseJson.put("headers", headerJson);
            responseJson.put("body", responseBody.toJSONString());  

        } catch(ParseException pex) {
            responseJson.put("statusCode", "403");
            responseJson.put("exception", pex);
        }

        logger.log(responseJson.toJSONString());
        OutputStreamWriter writer = new OutputStreamWriter(outputStream, "UTF-8");
        writer.write(responseJson.toJSONString());  
        writer.close();
    }
}
/*
{
    "isBase64Encoded": true|false,
    "statusCode": httpStatusCode,
    "headers": { "headerName": "headerValue", ... },
    "body": "..."
}

{
  "isBase64Encoded": false,
  "headers": {
    "x-custom-header": "my custom header value"
  },
  "body": "{\"input\":\"{\\\"username\\\":\\\"tonyschndr@gmail.com\\\"}\"}",
  "statusCode": "200"
}

{
    "isBase64Encoded":false,
    "headers": {
        "x-custom-header":"my custom header value"
    },
    "body":"",
    "statusCode":"200"
}

{"isBase64Encoded":"false",
 "headers":{"x-custom-header":"my custom header value"},
 "body":"",
 "statusCode":"200"}
*/