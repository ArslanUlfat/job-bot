require 'httparty'
require 'json'
require 'dotenv/load'
require 'date'
require 'byebug'

class PythonJobBot
  def run
    api_key   = ENV['OPENROUTER_API_KEY']
    slack_url = ENV['PYTHON_SLACK_WEBHOOK_URL']

    date = Date.today.strftime('%B %d, %Y')

    question = "Search Google for 5 currently active remote job postings as of #{date} that require experience with Python, specifically Django or FastAPI. For each listing, include the job title, company name, location (if specified), and a direct link to the job posting."

    response = HTTParty.post(
      'https://openrouter.ai/api/v1/chat/completions',
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}"
      },
      body: {
        model: 'moonshotai/kimi-k2:free',
        messages: [
          { role: 'user', content: question }
        ]
      }.to_json
    )

    answer = JSON.parse(response.body)['choices'][0]['message']['content']

    HTTParty.post(
      slack_url,
      body: { text: "*Remote Python Jobs!*\n#{answer}" }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end

PythonJobBot.new.run
