from flask import Flask, Response
from flask import request
from flask_cors import cross_origin

from recipe_utils import process_sentence

app = Flask(__name__)
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route('/recipe', methods=['POST'])
@cross_origin()
def get_json():
    """
    Gets the tree for a recipe
    @return: the recipe's tree
    """
    if request.method == 'POST':
        sentence = request.get_json().get('sentence').lower()
        return Response(process_sentence(sentence), mimetype='application/json')
    else:
        return "-1"


if __name__ == '__main__':
    app.run()
