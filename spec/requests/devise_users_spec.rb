require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:user_params) { FactoryBot.attributes_for(:user) }
  let(:invalid_user_params) { FactoryBot.attributes_for(:user, email: "") }
  describe "#create" do
    context "パラメータが妥当な場合" do
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: user_params }
        expect(response).to have_http_status "302"
      end
      it "createが成功すること" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end
      it "ルーとパスにリダイレクトすること" do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_url
      end
    end
    context "パラメータが不正な場合" do
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response).to have_http_status "200"
      end
      it "createが失敗すること" do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.to_not change(User, :count)
      end
      it "エラーが表示されること" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include("2 errors prohibited this user from being saved")
      end
    end
  end
  describe "#edit" do 
    subject { get edit_user_registration_path }
    context "ログインしている場合" do
      before do
        sign_in user
      end
      it "リクエストが成功すること" do
        is_expected.to eq 200
      end
    end
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトすること" do
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end