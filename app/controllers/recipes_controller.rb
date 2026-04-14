class RecipesController < ApplicationController
  def new
  end

  def create
    ingredients = params[:ingredients]

    # サービスオブジェクトを呼び出す。プロンプト構築の詳細はサービス側が知っている
    client = GeminiClient.new
    @recipe = client.suggest_recipe(ingredients)
    
    render :new if @recipe.nil? # エラー時は入力画面に戻すなど
  end
end
