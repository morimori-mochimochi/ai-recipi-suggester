class RecipesController < ApplicationController
  def new
  end

  def create
    ingredients = params[:ingredients]

    # サービスオブジェクトを呼び出す。プロンプト構築の詳細はサービス側が知っている
    response_text = GeminiClient.new.suggest_recipe(ingredients)

    if response_text
      # AIから返ってきた文字列をJSONとして解析し、ハッシュに変換する
      @recipe = JSON.parse(response_text)
    else
      flash[:alert] = "レシピの生成に失敗しました。"
      render :new
    end
  end
end
