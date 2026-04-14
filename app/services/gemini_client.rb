class GeminiClient
  def initialize
    api_key = ENV['GEMINI_API_KEY']
    @client = Gemini::Client.new(api_key: api_key)
  end

  def suggest_recipe(ingredients)
    return nil if ingredients.blank?

    prompt = build_prompt(ingredients)
    
    begin
      # モデルを明示的に指定します。gemini-2.5-flash は高速でレシピ生成のようなタスクに最適です。
      response = @client.generate_content({
        contents: [{
          role: 'user',
          parts: [{ text: prompt }]
        }]
      }, model: "gemini-2.5-flash")
      # responseの構造は利用するgemの仕様に合わせて調整してください
      response.dig("candidates", 0, "content", "parts", 0, "text")
    rescue => e
      Rails.logger.error "Gemini API Error: #{e.message}"
      nil
    end
  end

  private

  # ここでプロンプトのチューニング（プロンプトエンジニアリング）を行う
  def build_prompt(ingredients)
    <<~PROMPT
      あなたはプロの料理研究家です。以下の材料を使って、家庭で簡単に作れる美味しいレシピを1つ提案してください。
      材料: #{ingredients}
      以下のJSON形式で、キーや値の型も完全に守って応答してください。
      {
        "recipeName ": "料理名",
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
  end
end