require "net/http"
require "json"
require "uri"

class GeminiClient
  API_KEY = Rails.application.credentials.dig(:google_ai, :api_keys)
  # 現在の最新モデル（1.5-flash または 2.0-flash）を指定します
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

  def suggest_recipe(ingredients)
    uri = URI("#{API_URL}?key=#{API_KEY}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    
    prompt = <<~PROMPT
      あなたはプロの料理研究家です。以下の材料を使って、家庭で簡単に作れる美味しいレシピを1つ提案してください。
      材料: #{ingredients}
      以下のJSON形式で、キーや値の型も完全に守って応答してください。
      {
        "recipeName": "料理名",
        "description": "料理の説明",
        "ingredients": [
          { "name": "材料名", "quantity": "分量" }
        ],
        "instructions": [
           "手順1",
           "手順2"
        ]
      }
    PROMPT

    request.body = {
      contents: [{ parts: [{ text: prompt }] }],
      generationConfig: {
        response_mime_type: "application/json"
      }
    }.to_json

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error "Gemini API Error: #{response.code} - #{response.body}"
      return nil
    end

    json = JSON.parse(response.body)

    # AIの回答テキスト部分のみを抽出して返す
    json.dig("candidates", 0, "content", "parts", 0, "text")
  end
end