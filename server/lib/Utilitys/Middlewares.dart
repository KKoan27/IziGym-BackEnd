import 'dart:convert';

import 'package:shelf/shelf.dart';


const Map<String,String> corsHeaders = {  
                                'Access-Control-Allow-Origin': '*',
                                'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
                                'Access-Control-Allow-Headers': 'Origin, Content-Type'};


    Middleware standardRespondeMiddleware (){

            return createMiddleware(
            
               requestHandler: (request) {
                     if(request.method == 'OPTIONS'){

                            return Response.ok('', headers: corsHeaders);

                     }

                     return null;
               }, 
                
                responseHandler: (originalresponse)async  {
            String originalResponseString = await originalresponse.readAsString();
            dynamic responseBody;
                if(originalResponseString.isNotEmpty){

                    try{
                        responseBody = jsonDecode(originalResponseString);
                    }
                    catch(_){
                        responseBody = originalResponseString;
                    }
                }    else{
                    responseBody = {};
                }
                
            return originalresponse.change(
                headers: { ...corsHeaders,...originalresponse.headers, 'Content-Type' : 'application/json'},
                body: jsonEncode({
            'statusCode': originalresponse.statusCode,
            'response': responseBody, 
            }));
            } 
            
            
        , errorHandler:(e , stack) =>  Response.internalServerError(
           headers: { 
        ...corsHeaders, 
        'Content-Type': 'application/json' 
      },
            body: jsonEncode( {
            'statusCode': 500,
            'response': {
                'error': 'Ocorreu um erro interno no servidor.',
                'details': e.toString(),
                'stack' : stack.toString()
            },
            })
        )
            );
    }