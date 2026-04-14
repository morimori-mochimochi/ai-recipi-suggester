class GeminiClient
  require 'google/generative_ai' # 使用するgemに合わせて変更してください

  def initialize
    api_key = ENV['GEMINI_API_KEY']
    @gen_ai = Google::GenerativeAI.new(api_key: api_key)
    @model = @gen_ai.model("gemini-1.5-flash") # 最新の適切なモデルを指定
  end

  def suggest_recipe(ingredients)
    return nil if ingredients.blank?

    prompt = build_prompt(ingredients)
    
    begin
      response = @model.generate_content(prompt)
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