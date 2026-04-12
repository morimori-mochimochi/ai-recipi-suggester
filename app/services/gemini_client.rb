class GeminiClient
  def initialize
    @client = Gemini::Client.new(
      api_key: Rails.application.credentials.google_ai[:api_keys]
    )
  end

  # レシピ提案専用のメソッドを作ることで、コントローラーをスッキリさせる
  def suggest_recipe(ingredients)
    prompt = "以下の材料を使って、10分で作れるレシピを提案してください：#{ingredients}"
    
    response = @client.generate_content(prompt)
    
    # 必要に応じてレスポンスの加工ロジックもここに書ける
    response
  end
 end
