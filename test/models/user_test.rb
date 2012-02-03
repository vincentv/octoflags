require_relative '../helper.rb'

describe Api::V1::Models::User do
  before do
    Api::V1::Models::User.delete_all
    Api::V1::Models::Repository.delete_all

    @user = Factory.create(:basic_user)
  end

  it "must be unique" do
    Factory.build(:basic_user).save.must_equal false
  end

  describe "with repository" do
    before do
      @repo = Factory.create(:basic_repo)
    end

    it "can flag repository" do
      @user.flag @repo.id
      @user.flags.length.must_equal 1
    end


    it "can't flag repository if previously flagged" do

      2.times do
        @user.flag @repo.id
        @user.flags.length.must_equal 1
      end
    end

    describe "with repository flagged" do
      before do
        @user.flag @repo.id
      end

      it "can unflag repository" do
        @user.unflag @repo.id
        @user.repositories.length.must_equal 0
      end

      it "can't unflag repository if not previously flagged" do
        2.times do
          @user.unflag @repo.id
          @user.repositories.length.must_equal 0
        end
      end
    end
  end

end
