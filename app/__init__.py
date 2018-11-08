import json
import os

from flask import Flask, request, jsonify

application = Flask(__name__)


@application.route("/", methods=['POST'])
def write_data():
    """
    Write any json data received, to a temporal folder. This data will be, later on, read by other services.
    :return:
    """
    with open('/tmp/{}'.format(os.environ.get('PAYLOAD_FILENAME', 'data.json')), 'a') as out:
        out.write(json.dumps(json.loads(request.data)))

    return jsonify({
        'status_code': 200
    })
