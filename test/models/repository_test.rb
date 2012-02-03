require_relative '../helper.rb'

describe Api::V1::Models::Repository do
  before do
    Api::V1::Models::Repository.delete_all
  end

  describe "with new repository" do
    before do
      @repo = Factory.create(:basic_repo)
    end

    it "must be unique" do
      Factory.build(:basic_repo).save.must_equal false
    end

    it "is un unflagged repository" do
      @repo.marked.must_equal 0
    end

    it "can flag repository" do
      @repo.flag
      @repo.marked.must_equal 1
    end
  end

  describe "with flagged repository" do
    before do
      @repo = Factory.create(:flagged_repo)
    end
    it "can unflag repository" do
      @repo.unflag
      @repo.marked.must_equal 41
    end
  end
end
