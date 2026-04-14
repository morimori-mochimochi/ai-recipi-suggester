class GeminiClient
  def initialize
    api_key = ENV['GEMINI_API_KEY']
    @client = Gemini::Client.new(api_key: api_key)
  end

  def suggest_recipe(ingredients)
    return nil if ingredients.blank?

    prompt = build_prompt(ingredients)
    
    begin
      # gemini-ai gem の仕様に合わせた呼び出し方
      # モデル名は引数またはClient作成時に指定できます（デフォルトは gemini-1.5-flash など）
      response = @client.generate_content({
        contents: [{
          role: 'user',
          parts: [{ text: prompt }]
        }]
      })
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
      料理名、材料の分量、手順を分かりやすく出力してください。
    PROMPT
  end
end