# 🤖 AI Chatbot — Flutter + LLaMA 3 + Flask

A simple AI-powered chatbot mobile application built with **Flutter**, **Flask**, **LangChain**, **Ollama**, and **LLaMA 3 (8B)**.

The application provides a conversational chat interface where users can ask general questions and receive AI-generated responses from a locally hosted LLaMA 3 model.

---

## 📌 Overview

This project demonstrates how a **Flutter mobile application** can communicate with a **Python Flask backend**, which processes user prompts using **LangChain** and a locally running **LLaMA 3 model through Ollama**.

### Architecture

```text
┌──────────────────────┐
│     Flutter App      │
│                      │
│   ChatScreen.dart    │
└──────────┬───────────┘
           │
           │ HTTP POST
           │ /generate
           ▼
┌──────────────────────┐
│    Flask Backend     │
│                      │
│       app.py         │
└──────────┬───────────┘
           │
           │ LangChain
           ▼
┌──────────────────────┐
│       Ollama         │
│                      │
│    LLaMA 3 8B        │
└──────────┬───────────┘
           │
           │ AI Response
           ▼
┌──────────────────────┐
│     Flutter App      │
│   Displays Response  │
└──────────────────────┘
```

---

## ✨ Features

- 💬 Interactive chatbot interface
- 🤖 AI-generated responses using **LLaMA 3 8B**
- 📱 Cross-platform Flutter frontend
- 🐍 Python Flask REST API backend
- 🔗 LangChain integration for prompt management and LLM interaction
- 🏠 Runs LLaMA locally using Ollama
- ⌨️ Typing indicator while waiting for the AI response
- 📜 Automatically scrolls to the latest message
- 👤 Separate user and chatbot message bubbles
- 🌐 Communication between Flutter and Flask using HTTP/JSON
- 🔒 No external AI API key required for the LLaMA inference layer

---

## 🛠️ Tech Stack

### Frontend

- **Flutter**
- **Dart**
- Material UI
- HTTP package

### Backend

- **Python**
- **Flask**
- **LangChain**

### AI / LLM

- **LLaMA 3 8B**
- **Ollama**

### Communication

- REST API
- JSON
- HTTP POST

---

## 📂 Project Structure

```text
AI-Chatbot/
│
├── backend/
│   └── app.py
│
├── flutter_app/
│   ├── lib/
│   │   ├── main.dart
│   │   │
│   │   ├── screens/
│   │   │   └── chat_screen.dart
│   │   │
│   │   └── services/
│   │       └── chat_services.dart
│   │
│   └── pubspec.yaml
│
├── README.md
└── .gitignore
```

> Your exact folder structure may differ depending on how you organize the Flutter and Flask projects.

---

# ⚙️ How It Works

The application follows a simple request-response architecture.

### 1. User enters a message

The user enters a question in the Flutter chat interface.

```text
"How are you?"
```

### 2. Flutter sends the request

The Flutter application sends an HTTP POST request to the Flask backend.

```json
{
  "prompt": "How are you?"
}
```

### 3. Flask receives the prompt

The Flask server exposes the following endpoint:

```text
POST /generate
```

The backend extracts the prompt from the incoming JSON request.

### 4. LangChain processes the prompt

The prompt is inserted into a predefined `PromptTemplate`.

The backend then passes the prompt to the LLaMA model through LangChain.

### 5. Ollama runs LLaMA locally

Ollama hosts the LLaMA 3 8B model locally at:

```text
http://localhost:11434
```

The model generates an AI response.

### 6. Flask returns the response

The backend returns JSON:

```json
{
  "response": "I'm doing well! How can I help you?"
}
```

### 7. Flutter displays the response

The Flutter application receives the response and adds it to the chat interface.

---

# 🚀 Getting Started

## Prerequisites

Make sure you have the following installed:

- Flutter SDK
- Dart SDK
- Python 3.x
- pip
- Ollama
- LLaMA 3 model

You can verify the installations:

```bash
flutter --version
python --version
pip --version
ollama --version
```

---

# 🧠 Step 1 — Install Ollama

Install Ollama from its official website:

[Ollama](https://ollama.com/?utm_source=chatgpt.com)

After installation, download the LLaMA 3 8B model:

```bash
ollama pull llama3:8b
```

Run Ollama:

```bash
ollama serve
```

The model should be available through:

```text
http://localhost:11434
```

---

# 🐍 Step 2 — Set Up the Flask Backend

Navigate to the backend directory:

```bash
cd backend
```

Create a virtual environment:

### Windows

```bash
python -m venv venv
venv\Scripts\activate
```

### Linux / macOS

```bash
python3 -m venv venv
source venv/bin/activate
```

Install the required dependencies:

```bash
pip install flask langchain
```

Depending on your installed LangChain version, you may also need the appropriate Ollama integration package.

Then start the Flask server:

```bash
python app.py
```

The API will run on:

```text
http://localhost:5000
```

---

# 📱 Step 3 — Set Up the Flutter Application

Navigate to the Flutter project:

```bash
cd flutter_app
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# 🔌 API Documentation

## Generate Chat Response

### Endpoint

```text
POST /generate
```

### Request

```json
{
  "prompt": "What is artificial intelligence?"
}
```

### Response

```json
{
  "response": "Artificial intelligence is..."
}
```

### Example using cURL

```bash
curl -X POST http://localhost:5000/generate \
-H "Content-Type: application/json" \
-d "{\"prompt\":\"What is artificial intelligence?\"}"
```

---

# 📱 Flutter Communication

The Flutter application communicates with the backend through the `ChatService` class.

The request is sent using:

```dart
http.post()
```

with JSON data:

```dart
jsonEncode({
  'prompt': prompt
})
```

The response is then decoded:

```dart
jsonDecode(response.body)['response'];
```

---

# 🖥️ Running on a Physical Android Device

When running the Flutter application on a physical phone, `localhost` refers to the phone itself, not your computer.

Therefore, use your computer's local network IP address in:

```text
chat_services.dart
```

For example:

```dart
final String baseUrl = 'http://192.168.x.x:5000';
```

Make sure:

1. Your phone and computer are connected to the same Wi-Fi network.
2. Flask is running with:

```python
app.run(host="0.0.0.0", port=5000)
```

3. Your firewall allows connections to port `5000`.

> **Important:** Do not commit your personal/local IP address to GitHub. Replace it with a configurable value or example address before publishing the repository.

---

# 🧩 Backend Prompt

The chatbot uses a prompt template to provide context to the LLaMA model.

```python
TEMPLATE = """
You are a chat bot which is running on a flutter app.
The user will ask you very generic questions,
like how are you, how is it going,
and maybe some General knowledge questions.

Here is the user input:

{country}

Answer the question without letting them know
that you're running in background.
"""
```

The prompt is then passed to the LLM through LangChain.

---

# 🔄 Application Flow

```text
User
 │
 ▼
Flutter Chat UI
 │
 │ User enters prompt
 ▼
ChatService
 │
 │ HTTP POST
 ▼
Flask API
 │
 ▼
LangChain
 │
 ▼
Prompt Template
 │
 ▼
Ollama
 │
 ▼
LLaMA 3 8B
 │
 │ Generated response
 ▼
Flask API
 │
 │ JSON response
 ▼
Flutter
 │
 ▼
Chat UI
```

---

# 🧪 Example Conversation

```text
User:
What is machine learning?

AI:
Machine learning is a branch of artificial intelligence
that enables computers to learn patterns from data and
make predictions or decisions without being explicitly
programmed for every task.
```

Another example:

```text
User:
How are you?

AI:
I'm doing well! Thanks for asking. How can I help you today?
```

---

# 🎯 Learning Objectives

This project was developed to understand and demonstrate:

- Building a mobile application using Flutter
- Creating REST APIs using Flask
- Connecting Flutter applications with Python backends
- Working with locally hosted Large Language Models
- Using Ollama for local LLM inference
- Integrating LangChain with an LLM
- Designing prompt templates
- Handling HTTP requests and JSON responses
- Building a real-time conversational UI
- Structuring a frontend-backend AI application

---

# 🔮 Future Improvements

Possible improvements for future versions include:

- 💾 Chat history persistence
- 🧠 Conversation memory
- 🎙️ Voice input and output
- 🌙 Dark mode
- 👤 User authentication
- ⚡ Streaming AI responses
- 📡 WebSocket-based communication
- 🗃️ Database integration
- ☁️ Cloud deployment
- 🔐 Environment-based configuration
- 🧪 Automated API testing
- 📊 Response evaluation and monitoring
- 🔄 Support for multiple LLM models

---

# ⚠️ Current Limitations

- The LLaMA model must be available locally through Ollama.
- The backend must be running for the Flutter application to communicate with the chatbot.
- Network configuration is required when using a physical mobile device.
- The current implementation does not persist conversations after the application session ends.
- The current API does not include authentication.
- The application currently uses a fixed backend URL.

---

# 🔐 Security Notes

Before publishing this project to GitHub:

- Do not commit private IP addresses.
- Do not commit API keys or passwords.
- Do not commit virtual environments.
- Do not commit build files or generated files unnecessarily.

A basic `.gitignore` should include:

```gitignore
# Python
venv/
__pycache__/
*.pyc

# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
build/

# IDE
.vscode/
.idea/

# Environment files
.env

# OS
.DS_Store
Thumbs.db
```

---

# 👨‍💻 Author

**Pratyush Kumar Singh**

Computer Science & Engineering Graduate

### Technologies

`Python` · `Flask` · `Flutter` · `Dart` · `LangChain` · `Ollama` · `LLaMA 3`

---

# ⭐ If You Like This Project

If you found this project useful or interesting, consider giving the repository a ⭐ on GitHub.

---
```


Also, your Python variable is named `country` even though it actually contains the **user's prompt**. For a polished GitHub project, I'd rename `country` → `prompt` throughout `app.py`. That will make the code much easier for an interviewer/recruiter to understand.

If you're putting this project on your resume/GitHub portfolio, I would also recommend adding **2–3 screenshots and a small architecture diagram** to the README—the project will look substantially more professional.
