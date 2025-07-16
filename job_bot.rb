require 'httparty'
require 'json'
require 'dotenv/load'
require 'date'
require 'byebug'

class JobBot
  def run
    api_key   = ENV['OPENROUTER_API_KEY']
    slack_url = ENV['SLACK_WEBHOOK_URL']

    question = 'Search and list 5 active current remote job postings for Ruby on Rails from Google. Include the job title, company name, location and link for each listing.'

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
      body: { text: "☀️ Good morning!\n#{answer}" }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end

JobBot.new.run
