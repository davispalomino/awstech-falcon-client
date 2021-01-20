from aws_xray_sdk.core import patcher, xray_recorder
from aws_xray_sdk.ext.flask.middleware import XRayMiddleware
from boto3.dynamodb.conditions import Key, Attr
import boto3, time,json, logging
from datetime import datetime
from flask import Flask, Response, request, jsonify
from flask_cors import CORS

patcher.patch(('requests',))
app = Flask(__name__)
logging.basicConfig(level=logging.DEBUG)
CORS(app)

xray_recorder.configure(service='falcon-dev-backend')
logging.getLogger('aws_xray_sdk').setLevel(logging.DEBUG)
XRayMiddleware(app, xray_recorder)

__TableName__ = 'game-score'
Primary_Column_Name = 'id'
columns=['username', 'fullname', 'point', 'notes']

DB =     boto3.resource('dynamodb',region_name='us-east-1')
table = DB.Table(__TableName__)

def generatorTimeStamp():
    now = datetime.now()
    return int(datetime.timestamp(now) )

@app.route('/getElement')
def getElement():
    idKey = request.args.get('idKey')
    response = table.get_item(
                Key={
                    Primary_Column_Name:int(idKey)
                }
            )
    return app.response_class(
        response=(json.dumps({"result":"success","message":"query success","data":[response["Item"]]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json'
    )

@app.route('/health')
def healthCheck():
    return app.response_class(
        response=(json.dumps({"result":"success","message":"health UP","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json'
    )

@app.route('/putElement')
def putElement():
    username = request.args.get('username')
    fullname = request.args.get('fullname')
    point = request.args.get('point')
    notes = request.args.get('notes')
    response = table.put_item(
    Item={
        Primary_Column_Name:generatorTimeStamp(),
        columns[0]: username,
        columns[1]: fullname,
        columns[2]: point,
        columns[3]: notes
            }
        )
    if int(response["ResponseMetadata"]["HTTPStatusCode"]) == 200:
        return app.response_class(
        response=(json.dumps({"result":"success","message":"query success","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json')
    else:
        return app.response_class(
        response=(json.dumps({"result":"failed","message":"failed insert","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json')


@app.route('/deleteElement')
def deleteElement():
    idKey = request.args.get('idKey')
    response = table.delete_item( Key={ Primary_Column_Name: int(idKey) }) 
    if int(response["ResponseMetadata"]["HTTPStatusCode"]) == 200:
        return app.response_class(
        response=(json.dumps({"result":"success","message":"query success","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json')
    else:
        return app.response_class(
        response=(json.dumps({"result":"failed","message":"failed delete","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json')

def queryElements(idKey):
    response = table.query(
        KeyConditionExpression=Key('id').eq(idKey)
    )
    return app.response_class(
        response=(json.dumps(response["Items"],sort_keys="true", default=str)),
        status=200,
        mimetype='application/json'
    )


@app.route('/listarElemntTable')
def listarElemntTable():
    lista=[]
    response = table.scan(
        FilterExpression=Attr('id').gte(0)
    )
    for x in response["Items"]:
        x['functions']= "<div class=\"function_buttons\"><ul><li class=\"function_edit\"><a data-id=\""+str(x['id'])+"\" data-name=\""+str(x['fullname'])+"\"><span>Edit</span></a></li><li class=\"function_delete\"><a data-id=\""+str(x['id'])+"\" data-name=\""+str(x['fullname'])+"\"><span>Delete</span></a></li></ul></div>"
        lista.append(x)

    return app.response_class(
        response=json.dumps({"data":lista},sort_keys="true", default=str),
        status=200,
        mimetype='application/json'
    )

def searchElement(user):
    response = table.scan(FilterExpression=Attr('user').gte(user))
    return (int(response['Items'][0]['id']))


@app.route('/updateElementScore')
def updateElementScore():
    idKey = request.args.get('idKey')
    username = request.args.get('username')
    fullname = request.args.get('fullname')
    point = request.args.get('point')
    notes = request.args.get('notes')
    response = table.get_item(Key={'id': int(idKey)})
    item = response['Item']
    item['username'] = username
    item['fullname'] = fullname
    item['point'] = point
    item['notes'] = notes
    rpta = table.put_item(Item=item)
    if int(rpta["ResponseMetadata"]["HTTPStatusCode"]) == 200:
        return app.response_class(
        response=(json.dumps({"result":"success","message":"query success","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json')
    else:
        return app.response_class(
        response=(json.dumps({"result":"failed","message":"failed update","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json')


if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)