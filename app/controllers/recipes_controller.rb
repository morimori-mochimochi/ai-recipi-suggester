class RecipesController < ApplicationController
  def new
  end

  def create
    ingredients = params[:ingredients]

    # サービスオブジェクトを呼び出す。プロンプト構築の詳細はサービス側が知っている
    response_text = GeminiClient.new.suggest_recipe(ingredients)

    if response_text
      # AIから返ってきた文字列をJSONとして解析し、ハッシュに変換する
      begin
        @recipe = JSON.parse(response_text)
      rescue JSON::ParserError
        flash.now[:alert] = "レシピデータの解析に失敗しました。もう一度お試しください。"
        @recipe = nil
        render :new
      end
    else
      flash.now[:alert] = "レシピの生成に失敗しました。APIキーや通信状況を確認してください。"
      render :new
    end
  end
end
