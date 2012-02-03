FactoryGirl.define do

  factory :basic_user, :class => Api::V1::Models::User do |f|
    f.login "octocat"
    f.email "octocat@catocto.com"
  end
end
