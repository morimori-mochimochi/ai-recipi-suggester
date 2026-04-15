class GeminiClient

  require "net/http"
  require "json"
  require "uri"

  API_KEY = Rails.application.credentials.dig(:google_ai, :api_keys)

  uri = URI("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=#{API_KEY}")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri)
  request["Content-Type"] = "application/json"

  request.body = {
   contents: [
     {
       prompt: [
         <<~PROMPT
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
       ],
  response = http.request(request)
  json = JSON.parse(response.body)

  puts json.dig("candidates", 0, "content", "parts", 0, "text")
end