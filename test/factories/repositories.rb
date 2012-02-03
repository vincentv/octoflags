FactoryGirl.define do
  factory  :basic_repo, :class => Api::V1::Models::Repository do |f|
    f.owner "octocat"
    f.url "https://api.github.com/repos/octocat/Hello-World"
    f.name "Hello-World"
  end

  factory :flagged_repo, :parent => :basic_repo do |f|
    f.marked 42
  end

end
