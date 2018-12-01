package nfpbreastfeedinglambdas.cognitouserdisable;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.io.BufferedReader;
import java.io.Writer;

import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.lambda.runtime.Context; 
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.cognitoidentity.AmazonCognitoIdentityClientBuilder;
import com.amazonaws.services.cognitoidp.*;
import com.amazonaws.services.cognitoidp.model.AdminDisableUserRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.*;



public class DisableUserHandler implements RequestStreamHandler {
    JSONParser parser = new JSONParser();
    
    private static AWSCognitoIdentityProvider provider =  AWSCognitoIdentityProviderClientBuilder.standard()
    		.withRegion(Regions.US_EAST_1)
    		.defaultClient();


    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) throws IOException {
    	
        LambdaLogger logger = context.getLogger();
        logger.log("Loading Java Lambda handler of ProxyWithStream");


        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        JSONObject responseJson = new JSONObject();
   
        int responseCode = 200;

        try {
            JSONObject event = (JSONObject)parser.parse(reader);
            logger.log("Hello, here is the event: " + event.toJSONString());
            //logger.log(event.toJSONString());
            CognitoUser cognitoUser = new CognitoUser();
            
            if (event.get("body") != null) {
                JSONObject body = (JSONObject)parser.parse((String)event.get("body"));
                logger.log("JSON body"+body);
                cognitoUser.setUserName(body.get("username").toString());
                cognitoUser.setCognitoPoolID(body.get("userpool").toString());
            }
           
            //Disable User in cognito
            boolean isDisabled = true;
            try {
                AdminDisableUserRequest adminDisableUserRequest = new AdminDisableUserRequest();
                adminDisableUserRequest.setUsername(cognitoUser.getUserName());
                adminDisableUserRequest.setUserPoolId(cognitoUser.getCognitoPoolID());
                provider.adminDisableUser(adminDisableUserRequest);
            } catch (Exception e) {
                isDisabled = false;
                logger.log(e.toString());
            }
            
            
            JSONObject responseBody = new JSONObject();
            responseBody.put("input", event.toJSONString());

            JSONObject headerJson = new JSONObject();
            headerJson.put("x-custom-header", "my custom header value");

            responseJson.put("isBase64Encoded", false);
            responseJson.put("statusCode", responseCode);
            responseJson.put("headers", headerJson);
            if (isDisabled) {
                responseJson.put("body", "{\"disabled\" : \"true\"}");  
            } else {
                responseJson.put("body", "{\"disabled\" : \"false\"}");
            }
            

        } catch(ParseException pex) {
            responseJson.put("statusCode", 403);
            responseJson.put("exception", pex);
            
        }

        logger.log(responseJson.toJSONString());
        OutputStreamWriter writer = new OutputStreamWriter(outputStream, "UTF-8");
        writer.write(responseJson.toJSONString());  
        writer.close();
    }
    
     class CognitoUser {
    	 
    	private String userName;
    	private String cognitoPoolID;
    	
    	public CognitoUser() {
    		
    	}
    	
    	public void setCognitoPoolID(String cognitoPoolID) {
    		this.cognitoPoolID = cognitoPoolID;
    	}
    	
    	public String getCognitoPoolID() {
    		return cognitoPoolID;
    	}
    	
    	public void setUserName(String userName) {
    		this.userName = userName;
    	}
    	
    	public String getUserName() {
    		return userName;
    	}
    }
}
