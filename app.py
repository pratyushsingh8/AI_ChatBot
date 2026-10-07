from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain
from langchain.llms import Ollama
from flask import Flask, request, jsonify
import logging
logging.basicConfig(level=logging.DEBUG)

# Define the prompt template
TEMPLATE = """
You are a chat bot which is running on a flutter app. The user will ask you very generic questions , like how are you 
, how is it going , and maybe some General knowledge questions here is the user input 
{country}

answer the question whithout letting them know that you're running in background
"""
ChatBotQuestion = PromptTemplate(input_variables=["country"], template=TEMPLATE)

# Initialize the LLM
llm = Ollama(base_url="http://localhost:11434", model="llama3:8b")

# Create the LLM chain
chain = LLMChain(llm=llm, prompt=ChatBotQuestion)

# Set up Flask
app = Flask(__name__)

@app.route("/generate", methods=["POST"])
def generate():
    try:
        # Parse input from the request
        data = request.json
        print(data)
        country = data.get("prompt")

        if not country:
            return jsonify({"error": f'{country , data} not a country'}), 400

        # Generate a response using the LLM chain
        response = chain.run({"country": country})
        return jsonify({"response": response})
    except Exception as e:
        app.logger.error(f"Error processing request: {e}")
        return jsonify({"error": "Internal Server Error"}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
