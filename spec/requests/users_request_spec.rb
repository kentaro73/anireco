require 'rails_helper'

RSpec.describe "Users", type: :request do

  # ユーザー詳細ページ
  describe "#show" do
    context "ユーザーが存在しない場合" do
      subject { -> { get user_path 1 } }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end
end
