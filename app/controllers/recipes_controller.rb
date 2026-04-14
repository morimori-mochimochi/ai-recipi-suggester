class RecipesController < ApplicationController
  def new
  end

  def create
    # 1. フォームから送信された材料を取得
    ingredients = params[:ingredients]

    # 2. GeminiClient サービスを使用して API を呼び出し、レスポンスを取得
    client = GeminiClient.new
    response = client.suggest_recipe(ingredients)

    # 3. API のレスポンスから生成されたテキスト（レシピ内容）を抽出
    # gemini-ai gem の場合、以下の構造でテキストを取得できます
    @recipe = response.dig("candidates", 0, "content", "parts", 0, "text")
  end
end
