package nfpbreastfeedinglambdas.dynamodbuploadsurveys;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;

import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.lambda.runtime.Context; 
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.simple.JSONObject;
import org.json.simple.parser.*;

import nfpbreastfeedinglambdas.nfpbreastfeedingsurveys.*;



public class UploadSurveyHandler implements RequestStreamHandler {
    JSONParser parser = new JSONParser();
    private BreastFeedingSurveys survey;
    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) throws IOException {
    	
        LambdaLogger logger = context.getLogger();
        logger.log("Loading Java Lambda handler of UploadSurveyHandler");


        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        JSONObject responseJson = new JSONObject();
        
        int responseCode = 200;

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            JSONObject event = (JSONObject)parser.parse(reader);
            JSONObject responseBody = new JSONObject();
            logger.log(event.toJSONString());
            
            if (event.get("body") != null) {
                JSONObject body = (JSONObject)parser.parse((String)event.get("body"));
                InputStream stream = new ByteArrayInputStream(body.toString().getBytes());
                try {
                    getSurvey(body, stream, objectMapper);
                } catch (IOException e) {
                    logger.log(e.toString());
                    responseCode = 400;
                    responseBody.put("Error", event.toJSONString());
                }
                logger.log("JSON body"+body);
            }
            
            
            
            responseBody.put("input", event.toJSONString());

            JSONObject headerJson = new JSONObject();
            //headerJson.put("x-custom-header", "my custom header value");
            responseJson.put("isBase64Encoded", false);
            responseJson.put("statusCode", responseCode);
            responseJson.put("headers", headerJson);
            responseJson.put("body", "{\"success\" : \"true\"}");  
           
            

        } catch(ParseException pex) {
            responseJson.put("statusCode", 403);
            responseJson.put("exception", pex);
            
        }

        logger.log(responseJson.toJSONString());
        OutputStreamWriter writer = new OutputStreamWriter(outputStream, "UTF-8");
        writer.write(responseJson.toJSONString());  
        writer.close();
    }

    private BreastFeedingSurveys getSurvey(JSONObject body, InputStream stream, ObjectMapper objectMapper) throws IOException  {
    	if (body.get("type").toString().contains("DailySurvey")) {
       	 survey = objectMapper.readValue(stream, DailySurvey.class);
      
       } else if (body.get("type").toString().contains("WeeklySurvey")) {
       	survey = objectMapper.readValue(stream, WeeklySurvey.class);
       
       } else if (body.get("type").toString().contains("Onboarding")) {
       	survey = objectMapper.readValue(stream, OnboardingSurvey.class);
      
       }
    	return survey;
    }

}
